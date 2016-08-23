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
    public var callback: (() -> ())?

    public func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        dispatch_async(dispatch_get_main_queue()) {
            completionHandler?(response: self.response, error: self.error)
            self.callback?()
        }
        return nil
    }

}
