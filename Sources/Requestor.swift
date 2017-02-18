//
//  Requestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 2/17/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Requestor protocol used to allow for default and custom requestor instances.
 */
public protocol Requestor {

    /** Base URL for the API endpoints. */
    var baseUrl: String { get set }

    /**
     Request method used for all API endpoint calls.

     - Parameters:
     - method: HTTP method
     - authenticated: Indicates if request is authenticated
     - path: Path for REST endpoing
     - params: Parameters for request
     - completionHandler: Callback
     - Returns: Task
     */
    @discardableResult
    func request(_ method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> URLSessionTask?

}
