//
//  JSONRequestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import StravaKit

public class JSONRequestor : Requestor {

    public var response: AnyObject?
    public var responses: [AnyObject]?
    public var error: NSError?
    public var callback: (() -> ())?

    public var baseUrl: String

    init() {
        baseUrl = StravaBaseURL
    }

    public func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        dispatch_async(dispatch_get_main_queue()) {
            if self.response == nil {
                if let responses = self.responses,
                    let firstResponse = responses.first {
                    self.response = firstResponse
                    var responses = responses
                    responses.removeFirst()
                    self.responses = responses
                }
            }
            completionHandler?(response: self.response, error: self.error)
            self.callback?()

            // advance to the next response if there are responses defined
            if self.responses != nil {
                self.response = nil
            }
        }
        return nil
    }

}
