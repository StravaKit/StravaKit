//
//  Strava.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/18/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//
// Implementation influenced by LyftKit created by Genady Okrain.
//
// Strava API
// See: http://strava.github.io/api/

import Foundation
import Security

/** JSON Dictionary */
public typealias JSONDictionary = [String : AnyObject]
/** JSON Array */
public typealias JSONArray = [JSONDictionary]
/** Params Dictionary */
public typealias ParamsDictionary = [String : AnyObject]

/** Strava Base URL */
public let StravaBaseURL = "https://www.strava.com"
/** Strava Error Domain */
public let StravaErrorDomain = "StravaKit"

/** Rate Limit HTTP Header Key for Limit */
public let RateLimitLimitHeaderKey = "X-Ratelimit-Limit"
/** Rate Limit HTTP Header Key for Usage */
public let RateLimitUsageHeaderKey = "X-Ratelimit-Usage"

/** Rate Limit Notification Key for Limit */
public let RateLimitLimitKey = "Rate-Limit-Limit"
/** Rate Limit Notification Key for Usage */
public let RateLimitUsageKey = "Rate-Limit-Usage"

/**
 HTTP Methods

 - GET: Get method.
 - POST: Post method.
 - PUT: Put method.
 */
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

/**
 Strava Error Codes

 - RemoteError: Error on backend.
 - MissingCredentials: Required credentials were missing.
 - NoAccessToken: Access Token was not found.
 - NoResponse: Response was not returned.
 - InvalidResponse: Response was not expected.
 - RecordNotFound: Requested resource was not found.
 - RateLimitExceeded: Request exceeded rate limit. See error for details.
 - AccessForbidden: Access is not allowed.
 - UndefinedError: Reason for error is not known.
 */
public enum StravaErrorCode: Int {
    case RemoteError = 501
    case InvalidParameters = 502
    case MissingCredentials = 503
    case NoAccessToken = 504
    case NoResponse = 505
    case InvalidResponse = 506
    case RecordNotFound = 507
    case RateLimitExceeded = 508
    case AccessForbidden = 509
    case UndefinedError = 599
}

/**
 Strava class for handling all API endpoint requests.
 */
public class Strava {
    static let sharedInstance = Strava()
    internal let dateFormatter = NSDateFormatter()
    internal var clientId: String?
    internal var clientSecret: String?
    internal var redirectURI: String?
    internal var accessToken: String?
    internal var athlete: Athlete?
    internal var defaultRequestor: Requestor = DefaultRequestor()
    internal var alternateRequestor: Requestor?
    internal var isDebugging: Bool = false

    /**
     Strava initializer which should not be accessed externally.
     */
    internal init() {
        loadAccessData()

        // Use ISO 8601 standard format for date strings
        // Docs: http://strava.github.io/api/#dates
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    }

    /**
     Indicates if the current athlete is defined with a profile and access token.
     */
    public static var isAuthorized: Bool {
        get {
            return sharedInstance.accessToken != nil && sharedInstance.athlete != nil
        }
    }

    /**
     Current Athlete which is authorized.
     */
    public static var currentAthlete: Athlete? {
        get {
            return sharedInstance.athlete
        }
    }

    /**
     Allows for enabling debugging. It is false by default.
     */
    public static var isDebugging: Bool {
        get {
            return sharedInstance.isDebugging
        }
        set {
            sharedInstance.isDebugging = newValue
        }
    }

    /**
     Request method for all StravaKit API endpoint calls.
     */
    public static func request(method: HTTPMethod, authenticated: Bool, path: String, params: [String: AnyObject]?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        if isDebugging {
            debugPrint("Method: \(method.rawValue), Path: \(path), Authenticated: \(authenticated)")
            if let params = params {
                debugPrint("Params: \(params)")
            }
        }
        if let alternateRequestor = sharedInstance.alternateRequestor {
            return alternateRequestor.request(method, authenticated: authenticated, path: path, params: params, completionHandler: completionHandler)
        }

        return sharedInstance.defaultRequestor.request(method, authenticated: authenticated, path: path, params: params, completionHandler: completionHandler)
    }

    // MARK: - Internal Functions -

    internal static func error(code: StravaErrorCode, reason: String, userInfo: [String : AnyObject]? = [:]) -> NSError {
        var dictionary: [String : AnyObject]? = userInfo
        dictionary?[NSLocalizedDescriptionKey] = reason

        let error = NSError(domain: StravaErrorDomain, code: code.rawValue, userInfo: dictionary)
        return error
    }

    internal static func urlWithString(string: String?, parameters: JSONDictionary?) -> NSURL? {
        guard let string = string else {
            return nil
        }

        let URL = NSURL(string: string)
        if let parameters = parameters {
            return appendQueryParameters(parameters, URL: URL)
        }

        return URL
    }

    internal static func appendQueryParameters(parameters: JSONDictionary, URL: NSURL?) -> NSURL? {
        guard let URL = URL,
            let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false) else {
                return nil
        }

        var queryItems: [NSURLQueryItem] = []

        for key in parameters.keys {
            let value = parameters[key]
            if let stringValue = value as? String {
                let queryItem : NSURLQueryItem = NSURLQueryItem(name: key, value: stringValue)
                queryItems.append(queryItem)
            }
            else if let value = value {
                let stringValue = "\(value)"
                let queryItem : NSURLQueryItem = NSURLQueryItem(name: key, value: stringValue)
                queryItems.append(queryItem)
            }
        }

        components.queryItems = queryItems

        return components.URL
    }

    internal static func dateFromString(string: String?) -> NSDate? {
        if let string = string {
            return sharedInstance.dateFormatter.dateFromString(string)
        }
        return nil
    }
    
}
