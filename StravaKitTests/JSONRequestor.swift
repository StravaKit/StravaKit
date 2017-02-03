//
//  JSONRequestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import StravaKit

open class JSONRequestor : Requestor {

    open var response: Any?
    open var responses: [Any]?
    open var error: NSError?
    open var callback: (() -> ())?

    open var baseUrl: String

    init() {
        baseUrl = StravaBaseURL
    }

    open func request(_ method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        DispatchQueue.main.async { [weak self] in
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
            completionHandler?(s.response, s.error)
            s.callback?()

            // advance to the next response if there are responses defined
            if s.responses != nil {
                s.response = nil
            }
        }
        return nil
    }

}
