//
//  LocalizedString.swift
//  Template
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

internal func LocalizedString(_ key: String, comment: String?) -> String {
    struct Static {
        static let bundle = Bundle(identifier: "collab.com.Template.Model")!
    }
    return NSLocalizedString(key, bundle: Static.bundle, comment: comment ?? "")
}
