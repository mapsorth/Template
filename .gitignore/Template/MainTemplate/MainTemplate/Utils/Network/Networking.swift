//
//  Networking.swift
//

import ReactiveSwift
import SwiftyJSON

public protocol Networking {
  
  var result: MutableProperty<SwiftyJSON.JSON> { get }
  var error: MutableProperty<NetworkError> { get }
	// Method GET
	func GET(url: String, parameters: [String : Any]?)// -> SignalProducer<SwiftyJSON.JSON, NetworkError>
	
	// Method POST
	func POST(url: String, parameters: [String : Any]?)// -> SignalProducer<SwiftyJSON.JSON, NetworkError>
	
	// Method PUT
	func PUT(url: String, parameters: [String : Any]?)// -> SignalProducer<SwiftyJSON.JSON, NetworkError>
	
	// Method DELETE
	func DELETE(url: String, parameters: [String : Any]?)// -> SignalProducer<SwiftyJSON.JSON, NetworkError>
  
  // Method Multipart that works
  func Multipart(_ urlString: String, parameters: Dictionary<String, Any>?, fileData: Data, fileName: String, fileParameter: String)// -> SignalProducer<SwiftyJSON.JSON, NetworkError>
}
