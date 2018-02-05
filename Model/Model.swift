//
//  Model.swift
//  Model
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import Himotoki

struct SomeValue {
  let name: String
  let value: Int
  let array: [String]
}

extension SomeValue: Himotoki.Decodable {
  static func decode(_ e: Extractor) throws -> SomeValue {
    return try SomeValue(
      name: e <| "some_name",
      value: e <| "some_value",
      array: e <|| "some_array"
    )
  }
}
