//
//  StravaOAuth.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/20/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//
// Implementation influenced by LyftKit created by Genady Okrain.
//
// Docs: http://strava.github.io/api/v3/oauth/

import Foundation
import SafariServices

public let StravaAuthorizationCompletedNotification : String = "StravaAuthorizationCompleted"

public let StravaStatusKey: String = "status"
public let StravaErrorKey: String = "error"
public let StravaStatusSuccessValue: String = "success"
public let StravaStatusFailureValue: String = "failure"

internal enum OAuthResourcePath: String {
    case RequestAccess = "/oauth/authorize"
    case TokenExchange = "/oauth/token"
    case Deauthorization = "/oauth/deauthorize"
}

public enum OAuthScope: String {
    case Public = "public"
    case Write = "write"
    case Private = "view_private"
    case PrivateWrite = "view_private,write"
}

public extension Strava {
    // Initialize clientId & clientSecret
    static func set(clientId clientId: String, clientSecret: String, redirectURI: String, sandbox: Bool? = nil) {
        sharedInstance.clientId = clientId
        sharedInstance.clientSecret = clientSecret
        sharedInstance.redirectURI = redirectURI
    }

    // Provides URL used to initiate user login for use with a Safari View Controller
    // Docs: http://strava.github.io/api/v3/oauth/#get-authorize
    static func userLogin(scope scope: OAuthScope, state: String = "") -> NSURL? {
        guard let clientId = sharedInstance.clientId,
            _ = sharedInstance.clientSecret,
            redirectURI = sharedInstance.redirectURI else { return nil }

        let parameters : [String : AnyObject] = [
            "client_id" : clientId,
            "response_type" : "code",
            "redirect_uri" : redirectURI,
            "scope" : scope.rawValue,
            "state" : state,
            "approval_prompt" : "force"
        ]

        let path = OAuthResourcePath.RequestAccess.rawValue
        let URL = urlWithString("\(stravaBaseURL)/\(path)", parameters: parameters)
        return URL
    }
    
    // Handles the URL given to AppDelegate
    static func openURL(url: NSURL, sourceApplication: String?) -> Bool {
        guard let _ = sharedInstance.clientId,
            _ = sharedInstance.clientSecret else { return false }

        guard let sa = sourceApplication where sa == "com.apple.SafariViewService",
            let uri = sharedInstance.redirectURI,
            let _ = url.absoluteString.rangeOfString(uri) else {
                return false
        }

        guard let code = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)?.queryItems?.filter({ $0.name == "code" }).first?.value else { return false }

        exchangeTokenWithCode(code) { (success, error) in
            var userInfo: [String : AnyObject] = [:]
            userInfo[StravaStatusKey] = success ? StravaStatusSuccessValue : StravaStatusFailureValue
            if let error = error {
                userInfo[StravaErrorKey] = error
            }
            let nc = NSNotificationCenter.defaultCenter()
            let name = StravaAuthorizationCompletedNotification
            dispatch_sync(dispatch_get_main_queue()) {
                nc.postNotificationName(name, object: nil, userInfo: userInfo)
            }
        }

        return true
    }

    // Deauthorizes Strava access token
    // Docs: http://strava.github.io/api/v3/oauth/#deauthorize
    static func deauthorize(completionHandler: ((success: Bool, error: NSError?) -> ())?) {
        let path = OAuthResourcePath.Deauthorization.rawValue

        request(.POST, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(success: false, error: error)
            }

            sharedInstance.accessToken = nil
            sharedInstance.athlete = nil
            dispatch_sync(dispatch_get_main_queue()) {
                completionHandler?(success: true, error: nil)
            }
        }
    }

    // Exchanges code with the OAuth provider for the Access Token
    // Docs: http://strava.github.io/api/v3/oauth/#post-token
    internal static func exchangeTokenWithCode(code: String, completionHandler: ((success: Bool, error: NSError?) -> ())?) {
        guard let clientId = sharedInstance.clientId,
            clientSecret = sharedInstance.clientSecret else {
                let error : NSError = NSError(domain: "No clientId and clientSecret", code: 500, userInfo: nil)
                completionHandler?(success: false, error: error)
                return
        }

        let path = OAuthResourcePath.TokenExchange.rawValue
        let params: [String : AnyObject] = [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "code" : code
        ]

        request(.POST, authenticated: false, path: path, params: params) { (response, error) in
            if let error = error {
                completionHandler?(success: false, error: error)
            }
            guard let response = response,
                let accessToken = response["access_token"] as? String,
                let athleteDictionary = response["athlete"] as? [String : AnyObject] else {
                    let error : NSError = NSError(domain: "No clientId and clientSecret", code: 500, userInfo: nil)
                    completionHandler?(success: false, error: error)
                    return
            }

            sharedInstance.accessToken = accessToken
            sharedInstance.athlete = Athlete.athlete(athleteDictionary)
            assert(sharedInstance.athlete != nil, "Athlete is required")
            completionHandler?(success: true, error: nil)
        }
    }

}
