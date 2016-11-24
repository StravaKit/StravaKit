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
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            guard let s = self else {
                return
            }
            if s.response == nil {
                if let responses = s.responses,
                    let firstResponse = responses.first {
                    s.response = firstResponse
                    var responses = responses
                    responses.removeFirst()
                    s.responses = responses
                }
            }
            completionHandler?(response: s.response, error: s.error)
            s.callback?()

            // advance to the next response if there are responses defined
            if s.responses != nil {
                s.response = nil
            }
        }
        return nil
    }

}
