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

public typealias JSONDictionary = [String : AnyObject]
public typealias JSONArray = [JSONDictionary]
public typealias ParamsDictionary = [String : AnyObject]

public let StravaBaseURL = "https://www.strava.com"
public let StravaErrorDomain = "StravaKit"

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

public enum StravaErrorCode: Int {
    case RemoteError = 501
    case MissingCredentials = 502
    case NoAccessToken = 503
    case NoResponse = 504
    case InvalidResponse = 505
    case UndefinedError = 599
}

public class Strava {
    static let sharedInstance = Strava()
    internal var clientId: String?
    internal var clientSecret: String?
    internal var redirectURI: String?
    internal var accessToken: String?
    internal var athlete: Athlete?
    internal var defaultRequestor: Requestor = DefaultRequestor()
    internal var alternateRequestor: Requestor?

    init() {
        loadAccessData()
    }

    public static var isAuthenticated: Bool {
        get {
            return sharedInstance.accessToken != nil && sharedInstance.athlete != nil
        }
    }

    public static var currentAthlete: Athlete? {
        get {
            return sharedInstance.athlete
        }
    }

    public static func request(method: HTTPMethod, authenticated: Bool, path: String, params: [String: AnyObject]?, completionHandler: ((response: AnyObject?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        if let alternateRequestor = sharedInstance.alternateRequestor {
            return alternateRequestor.request(method, authenticated: authenticated, path: path, params: params, completionHandler: completionHandler)
        }
        
        return sharedInstance.defaultRequestor.request(method, authenticated: authenticated, path: path, params: params, completionHandler: completionHandler)
    }

    // MARK: - Internal Functions -

    internal static func error(code: StravaErrorCode, reason: String) -> NSError {
        let userInfo: [String : String] = [NSLocalizedDescriptionKey : reason]
        let error = NSError(domain: StravaErrorDomain, code: code.rawValue, userInfo: userInfo)
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


}
