//
//  Requestor.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Default Requestor used by the Strava class as the real implementation for requests.
 */
internal class DefaultRequestor: Requestor {

    /** Base URL for the API endpoints. */
    open var baseUrl: String

    init() {
        baseUrl = StravaBaseURL
    }

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
    open func request(_ method: HTTPMethod, authenticated: Bool, path: String, params: ParamsDictionary?, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        guard let url = Strava.urlWithString(baseUrl + path, parameters: method == .GET ? params : nil)
            else {
                let error = Strava.error(.unsupportedRequest, reason: "Unsupported Request")
                completionHandler?(nil, error)
                return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if method == .POST || method == .PUT {
            if let params = params {
                request.httpBody = convertParametersForBody(params)
            }
        }

        return processRequest(request, authenticated: authenticated, completionHandler: completionHandler)

    }

    // MARK: - Internal Functions -

    internal func processRequest(_ request: URLRequest, authenticated: Bool, completionHandler: ((_ response: Any?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let sessionConfiguration = URLSessionConfiguration.default
        if authenticated {
            guard let accessToken = Strava.sharedInstance.accessToken
                else {
                    let error = Strava.error(.noAccessToken, reason: "No Access Token")
                    completionHandler?(nil, error)
                    return nil
            }
            sessionConfiguration.httpAdditionalHeaders = ["Authorization": "Bearer \(accessToken)"]
        }
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse
                else {
                    fatalError("Response must be an instance of NSHTTPURLResponse")
            }

            if Strava.isDebugging {
                debugPrint("Status Code: \(httpResponse.statusCode)")
                if let MIMEType = httpResponse.mimeType {
                    debugPrint("Status Code: \(MIMEType)")
                }
                if let data = data {
                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                        debugPrint("Response: \(string)")
                    }
                }
            }

            if httpResponse.statusCode != 200 {
                if Strava.isDebugging {
                    self?.printResponse(httpResponse, data: data)
                }
                if httpResponse.statusCode == 401 {
                    let error = Strava.error(.accessForbidden, reason: "Access Forbidden")
                    completionHandler?(nil, error)
                    return
                }
                else if httpResponse.statusCode == 404 {
                    let error = Strava.error(.recordNotFound, reason: "Record Not Found")
                    completionHandler?(response, error)
                    return
                }
                else if httpResponse.statusCode == 500 {
                    let error = Strava.error(.remoteError, reason: "Remote Error")
                    completionHandler?(response, error)
                    return
                }
            }

            var response: Any? = nil
            if let data = data {
                do {
                    response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as Any?
                }
                catch {
                    let error = Strava.error(.undefinedError, reason: "Failure while parsing response.")
                    completionHandler?(nil, error)
                    return
                }
            }

            if httpResponse.statusCode == 403 {
                if let json = response as? JSONDictionary,
                    let message = json["message"] as? String {
                    if message == "Rate Limit Exceeded" {
                        var userInfo: [String : Any]? = nil
                        if let limit = httpResponse.allHeaderFields[RateLimitLimitHeaderKey] as? String,
                            let usage = httpResponse.allHeaderFields[RateLimitUsageHeaderKey] as? String {
                            userInfo = [
                                RateLimitLimitKey : limit,
                                RateLimitUsageKey : usage
                            ]
                        }

                        let error = Strava.error(.rateLimitExceeded, reason: "Rate Limit Exceeded", userInfo: userInfo)
                        completionHandler?(nil, error)
                    }
                    else {
                        let error = Strava.error(.accessForbidden, reason: "Access Forbidden", userInfo: nil)
                        completionHandler?(nil, error)
                    }
                }
                else {
                    let error = Strava.error(.accessForbidden, reason: "Access Forbidden")
                    completionHandler?(nil, error)
                }
            }
            else if response != nil {
                completionHandler?(response, error as NSError?)
            }
            else {
                let error = Strava.error(.undefinedError, reason: "Unknown Error")
                completionHandler?(nil, error)
            }
        })
        task.resume()
        return task
    }

    internal func convertParametersForBody(_ params: ParamsDictionary) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params, options: [])
    }

    internal func printResponse(_ response: HTTPURLResponse, data: Data?) {
        guard let data = data else {
            return
        }

        let string = String(data: data, encoding: String.Encoding.utf8)
        print("Response: \(String(describing: string))")
    }

}
