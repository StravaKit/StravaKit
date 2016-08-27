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
            guard let httpResponse = response as? NSHTTPURLResponse,
                let data = data else {
                    if let error = error {
                        completionHandler?(response: response, error: error)
                    }
                    else {
                        let error = Strava.error(.UndefinedError, reason: "Undefined Error")
                        completionHandler?(response: nil, error: error)
                    }
                    return
            }

            if httpResponse.statusCode != 200 {
                if httpResponse.statusCode == 404 {
                    let error = Strava.error(.RecordNotFound, reason: "Record Not Found")
                    completionHandler?(response: response, error: error)
                    return
                }
                else if httpResponse.statusCode == 500 {
                    let error = Strava.error(.RemoteError, reason: "Remote Error")
                    completionHandler?(response: response, error: error)
                    return
                }
            }

            if data.length == 0 {
                completionHandler?(response: [:], error: error)
            } else {
                do {
                    let response = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    if httpResponse.statusCode == 403 {
                        if let json = response as? JSONDictionary,
                            let message = json["message"] as? String where message == "Rate Limit Exceeded" {
                            var userInfo: [String : AnyObject]? = nil
                            if let limit = httpResponse.allHeaderFields[RateLimitLimitHeaderKey] as? String,
                                let usage = httpResponse.allHeaderFields[RateLimitUsageHeaderKey] as? String {
                                userInfo = [
                                    RateLimitLimitKey : limit,
                                    RateLimitUsageKey : usage
                                ]
                            }

                            let error = Strava.error(.RateLimitExceeded, reason: "Rate Limit Exceeded", userInfo: userInfo)
                            completionHandler?(response: response, error: error)
                        }
                        else {
                            let error = Strava.error(.AccessForbidden, reason: "Access Forbidden")
                            completionHandler?(response: response, error: error)
                        }
                    }
                    else {
                        completionHandler?(response: response, error: error)
                    }
                } catch {
                    let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                    completionHandler?(response: nil, error: error)
                }
            }

        }
        task.resume()
        return task
    }

}