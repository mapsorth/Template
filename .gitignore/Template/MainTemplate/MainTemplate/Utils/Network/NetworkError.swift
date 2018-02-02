//
//  NetworkError.swift
//

import Foundation

public enum NetworkError: Error {
  /// Unknown or not supported error.
  case unknown
  
  /// Not connected to the internet.
  case notConnectedToInternet
  
  /// International data roaming turned off.
  case internationalRoamingOff
  
  /// Cannot reach the server.
  case notReachedServer
  
  /// Connection is lost.
  case connectionLost
  
  /// Incorrect data returned from the server.
  case incorrectDataReturned
  
  case requestError(String)
  
  case failedMessage(String)
  
  internal init(error: Error, msg: String = "", status: RequestStatus = .changed) {
    let nsError = error as NSError
    if nsError.domain == NSURLErrorDomain {
      switch nsError.code {
      case NSURLErrorBadURL:
        self = .incorrectDataReturned // Because it is caused by a bad URL returned in a JSON response from the server.
      case NSURLErrorTimedOut,
           NSURLErrorCannotFindHost,
           NSURLErrorCannotConnectToHost,
           NSURLErrorDNSLookupFailed:
        self = .notReachedServer
      case NSURLErrorUnsupportedURL,
           NSURLErrorDataLengthExceedsMaximum,
           NSURLErrorResourceUnavailable,
           NSURLErrorNotConnectedToInternet:
        self = .incorrectDataReturned
      case NSURLErrorNetworkConnectionLost:
        self = .connectionLost
      case NSURLErrorRedirectToNonExistentLocation, NSURLErrorBadServerResponse:
        self = .incorrectDataReturned
      case NSURLErrorZeroByteResource, NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData:
        self = .incorrectDataReturned
      case NSURLErrorCannotParseResponse:
        self = .incorrectDataReturned
      case NSURLErrorInternationalRoamingOff:
        self = .internationalRoamingOff
      case NSURLErrorFileDoesNotExist, NSURLErrorFileIsDirectory:
        self = .incorrectDataReturned
      default:
        self = .unknown
      }
    } else {
      switch status {
        case .changed:
          self = .failedMessage(msg)
        case .notExists:
          self = .requestError(msg)
        default:
          self = .unknown
      }
    }
  }
  
  public var description: (String, Int) {
    let text: String
    var typeError: Int = 0
    switch self {
    case .unknown:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .notConnectedToInternet:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .internationalRoamingOff:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .notReachedServer:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .connectionLost:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .incorrectDataReturned:
      text = LocalizedString(serverFailed, comment: "Error description")
    case .requestError(let msg):
      text = msg
      typeError = 1
    case .failedMessage(let msg):
      text = msg
    }
    return (text, typeError)
  }
}
