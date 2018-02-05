//
//  Networking.swift
//  Model
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveSwift

public protocol Networking {
    /// Returns a `SignalProducer` emitting a JSON root element ( an array or dictionary).
    func requestJSON(_ url: String, parameters: [String : AnyObject]?) -> SignalProducer<Any, NetworkError>

}
