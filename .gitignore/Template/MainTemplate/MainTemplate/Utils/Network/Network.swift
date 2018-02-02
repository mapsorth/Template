import ReactiveSwift
import Alamofire
import SwiftyJSON
import Foundation

extension SessionManager {
  class func cancelRequest() {
      SessionManager.default.session.getAllTasks(completionHandler: { (tasks) -> Void in
        tasks.forEach({ $0.cancel() })
      })
  }
}

extension DataRequest {
  
  func responseToJSON(_ completionHandler: @escaping (URLRequest, HTTPURLResponse?, SwiftyJSON.JSON, Error?) -> Void) -> Self {
    return response { res in
      DispatchQueue.global().async {
        let responseJSON = res.data != nil ? SwiftyJSON.JSON(data: res.data!) : SwiftyJSON.JSON.null
        
        DispatchQueue.main.async {
          completionHandler(res.request!, res.response, responseJSON, res.error)
        }
      }
    }
  }
}

class Network: NSObject, Networking {
  
  // Class singleton
  static let sigleton = Network()
  
  // MARK: Lazy properties
  lazy var emptyError: NSError = { return NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil) }()
  
  var headers : [String: String]? {
    get {
      if "nm," != "" {
        return ["Content-Type": "application/json",
                "Authorization": "ghjtu"]
      }
      return nil
    }
  }
  
  override init() {}
  
  // MARK: Functions
  func cancelRequets() {
    Alamofire.SessionManager.cancelRequest()
  }
  
  func GET(url: String, parameters: [String : Any]?) {// -> SignalProducer<SwiftyJSON.JSON, NetworkError> {
   // return SignalProducer { observer, disposable in
      let request = Alamofire.request(url, method: .get, parameters: parameters, encoding: 
        JSONEncoding.default, headers: self.headers)
        .responseToJSON({ [weak self] (_, response, json, error) in
          guard let weakSelf = self else { return }
          
      })
      
      print(request)
   // }
  }
    
  func POST(url: String, parameters: [String : Any]?) -> SignalProducer<SwiftyJSON.JSON, NetworkError> {
    return SignalProducer { observer, disposable in
      // Block send request to sever in case the network connection be lost
      let mutableURLRequest = URLRequest(url: URL(string: url)!)
      let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
        .responseToJSON({ [weak self] (_, res, json, error) in
          guard let weakSelf = self else { return }
          if error != nil || !weakSelf.checkErrorResponse(res) {
            if let _ = json["error"].string {
              observer.send(value: json)
            } else {
              observer.send(error: NetworkError(error: error ?? weakSelf.emptyError))
            }
          } else {
            observer.send(value: json)
            observer.sendCompleted()
          }
        })
      print("request: \(request)")
    }
  }
  
  func PUT(url: String, parameters: [String : Any]?) -> SignalProducer<SwiftyJSON.JSON, NetworkError> {
    return SignalProducer { observer, disposable in
      // Block send request to sever in case the network connection be lost
      if !JReachabilityHelper.singleton.allowSendRequest {
        observer.sendInterrupted()
        return
      }
      let request = Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
        .responseToJSON({ [weak self] (_, res, json, error) in
          guard let weakSelf = self else { return }
          if error != nil || !weakSelf.checkErrorResponse(res) {
            if let _ = json["error"].string {
              observer.send(value: json)
            } else {
              observer.send(error: NetworkError(error: error ?? weakSelf.emptyError))
            }
          } else {
            observer.send(value: json)
            observer.sendCompleted()
          }
        })
      print("request: \(request)")
    }
  }
  
  func DELETE(url: String, parameters: [String : Any]? ) -> SignalProducer<SwiftyJSON.JSON, NetworkError> {
    return SignalProducer { observer, disposable in
      // Block send request to sever in case the network connection be lost
      if !JReachabilityHelper.singleton.allowSendRequest {
        observer.sendInterrupted()
        return
      }
      let request = Alamofire.request(url, method: .delete, parameters: parameters, headers: self.headers)
        .responseToJSON({ [weak self] (req, res, json, error) in
          guard let weakSelf = self else { return }
          if error != nil || !weakSelf.checkErrorResponse(res) {
            if let _ = json["error"].string {
              observer.send(value: json)
            } else {
              observer.send(error: NetworkError(error: error ?? weakSelf.emptyError))
            }
          } else {
            observer.send(value: json)
            observer.sendCompleted()
          }
        })
      print(request)
    }
  }
  
  func Multipart(_ urlString: String, parameters: Dictionary<String, Any>?, fileData: Data, fileName: String, fileParameter: String) -> SignalProducer<SwiftyJSON.JSON, NetworkError> {
    return SignalProducer { observer, disposable in
      Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(fileData, withName: fileParameter, fileName: fileName, mimeType: "")
        for (key, value) in parameters! {
          multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
        }
      }, usingThreshold: UInt64.init(),
         to: urlString,
         method: .put,
         headers: ["Authorization":self.headers!["Authorization"]!]) { (result) in
          switch result {
            case .success(let upload, _, _):
              upload.responseToJSON({ [weak self](_, res, json, error) in
              guard let weakSelf = self else { return }
              if error != nil || !weakSelf.checkErrorResponse(res) {
                if let _ = json["error"].string {
                  observer.send(value: json)
                } else {
                  observer.send(error: NetworkError(error: error ?? weakSelf.emptyError))
                }
              } else {
                observer.send(value: json)
                observer.sendCompleted()
                }
              })
          case .failure(let error):
            observer.send(error: NetworkError(error: error))
        }
      }
    }
  }
}
