//
//  MModel.swift
//  MModel
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Himotoki

public final class MModel: MModeling {
  private let network: Networking
  
  public init(network: Networking) {
    self.network = network
  }
  
  public func getModeling() -> SignalProducer<String, NetworkError> {
    let url = "https://apiURL.com"
    let parameters = ["key": "value" as AnyObject]
    return network.requestJSON(url, parameters: parameters)
      .attemptMap { json in
        if let response = (try? decodeValue(json) as String) {
       // if let response = (try? decode(json)) as String? {
          return Result(value: response)
        }
        else {
          return Result(error: .IncorrectDataReturned)
        }
    }
  }

}
