//
//  Requestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public protocol Requestor {

    func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask?

}

public class DefaultRequestor : Requestor {

    public func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        if let url = Strava.urlWithString(StravaBaseURL + path, parameters: method == .GET ? params : nil) {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                // Place parameters in body for POST and PUT methods
                if let params = params  where method == .POST || method == .PUT {
                    let body = try NSJSONSerialization.dataWithJSONObject(params, options: [])
                    request.HTTPBody = body
                }

                return processRequest(request, authenticated: authenticated, completionHandler: completionHandler)
            } catch {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(response: nil, error: error)
                return nil
            }
        }
        
        return nil
    }

    // MARK: - Internal Functions -

    internal func processRequest(request: NSURLRequest, authenticated: Bool, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        if authenticated {
            guard let accessToken = Strava.sharedInstance.accessToken else {
                let error = Strava.error(.NoAccessToken, reason: "No Access Token")
                completionHandler?(response: nil, error: error)
                return nil
            }
            sessionConfiguration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(accessToken)"]
        }
        let session = NSURLSession(configuration: sessionConfiguration)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let data = data {
                if data.length == 0 {
                    completionHandler?(response: [:], error: error)
                } else {
                    do {
                        let response = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        completionHandler?(response: response, error: error)
                    } catch {
                        let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                        completionHandler?(response: nil, error: error)
                    }
                }
            } else {
                let error = Strava.error(.NoResponse, reason: "No Response")
                completionHandler?(response: nil, error: error)
            }
        }
        task.resume()
        return task
    }

}