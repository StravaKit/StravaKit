//
//  Requestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Requestor protocol used to allow for default and custom requestor instances.
 */
public protocol Requestor {

    var baseUrl: String { get set }

    /**
     Request method used for all API endpoint calls.
     */
    func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask?

}

/**
 Default Requestor used by the Strava class as the real implementation for requests.
 */
public class DefaultRequestor : Requestor {

    public var baseUrl: String

    init() {
        baseUrl = StravaBaseURL
    }

    /**
     Request method used for all API endpoint calls.
     */
    public func request(method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        guard let url = Strava.urlWithString(baseUrl + path, parameters: method == .GET ? params : nil) else {
            let error = Strava.error(.UnsupportedRequest, reason: "Unsupported Request")
            completionHandler?(response: nil, error: error)
            return nil
        }

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if method == .POST || method == .PUT {
            if let params = params {
                request.HTTPBody = convertParametersForBody(params)
            }
        }

        return processRequest(request, authenticated: authenticated, completionHandler: completionHandler)

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
        let task = session.dataTaskWithRequest(request) { [weak self] data, response, error in
            guard let httpResponse = response as? NSHTTPURLResponse else {
                debugPrint("🔥🔥🔥")
                fatalError("Response must be an instance of NSHTTPURLResponse")
            }

            if Strava.isDebugging {
                debugPrint("Status Code: \(httpResponse.statusCode)")
                if let MIMEType = httpResponse.MIMEType {
                    debugPrint("Status Code: \(MIMEType)")
                }
                if let data = data {
                    if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                        debugPrint("Response: \(string)")
                    }
                }
            }

            if httpResponse.statusCode != 200 {
                if Strava.isDebugging {
                    self?.printResponse(httpResponse, data: data)
                }
                if httpResponse.statusCode == 401 {
                    let error = Strava.error(.AccessForbidden, reason: "Access Forbidden")
                    completionHandler?(response: nil, error: error)
                    return
                }
                else if httpResponse.statusCode == 404 {
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

            var response: AnyObject? = nil
            if let data = data {
                response = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }

            if httpResponse.statusCode == 403 {
                if let json = response as? JSONDictionary,
                    let message = json["message"] as? String {
                    if message == "Rate Limit Exceeded" {
                        var userInfo: [String : AnyObject]? = nil
                        if let limit = httpResponse.allHeaderFields[RateLimitLimitHeaderKey] as? String,
                            let usage = httpResponse.allHeaderFields[RateLimitUsageHeaderKey] as? String {
                            userInfo = [
                                RateLimitLimitKey : limit,
                                RateLimitUsageKey : usage
                            ]
                        }

                        let error = Strava.error(.RateLimitExceeded, reason: "Rate Limit Exceeded", userInfo: userInfo)
                        completionHandler?(response: nil, error: error)
                    }
                    else {
                        let error = Strava.error(.AccessForbidden, reason: "Access Forbidden", userInfo: nil)
                        completionHandler?(response: nil, error: error)
                    }
                }
                else {
                    let error = Strava.error(.AccessForbidden, reason: "Access Forbidden")
                    completionHandler?(response: nil, error: error)
                }
            }
            else if response != nil {
                completionHandler?(response: response, error: error)
            }
            else {
                let error = Strava.error(.UndefinedError, reason: "Unknown Error")
                completionHandler?(response: nil, error: error)
            }
        }
        task.resume()
        return task
    }

    internal func convertParametersForBody(params: ParamsDictionary) -> NSData? {
        return try? NSJSONSerialization.dataWithJSONObject(params, options: [])
    }

    internal func printResponse(response: NSHTTPURLResponse, data: NSData?) {
        guard let data = data else {
            return
        }

        let string = String(data: data, encoding: NSUTF8StringEncoding)
        print("Response: \(string)")
    }

}
