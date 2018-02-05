//
//  MModeling.swift
//  MModel
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

public protocol MModeling {
  func getModeling() -> SignalProducer<String, NetworkError>
}
