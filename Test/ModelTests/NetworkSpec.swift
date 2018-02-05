//
//  NetworkSpec.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Quick
import Nimble

@testable import MModel

/// Specificatios of Network.
/// As a stable network service, https://httpbin.org is used.
/// Refer to the website for its API details.
class NetworkSpec: QuickSpec {
    override func spec() {
        var network: Network!
        beforeEach {
            network = Network()
        }
        describe("JSON") {
            it("eventually gets JSON data as specified with parameters.") {
                var json: [String: Any]? = nil
                network.requestJSON("https://httpbin.org/get", parameters: ["a": "b" as AnyObject, "x": "y" as AnyObject])
                    .on(value: { json = $0 as? [String: Any] })
                    .start()
                
                expect(json).toEventuallyNot(beNil(), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["a"] as? String).toEventually(equal("b"), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["x"] as? String).toEventually(equal("y"), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                network.requestJSON("https://not.existing.server.comm/get", parameters: ["a": "b" as AnyObject, "x": "y" as AnyObject])
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }
        }
    }
}
