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
    public var error: NSError?

    public func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        completionHandler?(response: response, error: error)
        return nil
    }

}
