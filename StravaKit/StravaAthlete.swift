//
//  StravaAthlete.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/21/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum AthleteResourcePath: String {
    case Athlete = "/api/v3/athlete"
    case Athletes = "/api/v3/athletes/:id"
}

public extension Strava {

    static func getAthlete(completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athlete.rawValue

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(athlete: nil, error: error)
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    static func getAthlete(athleteId: Int, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athletes.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(athlete: nil, error: error)
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: Internal Functions

    internal static func handleAthleteResponse(response: [String : AnyObject]?, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) {
        if let dictionary = response,
            let athlete = Athlete.athlete(dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(athlete: athlete, error: nil)
            }
        }
        else {
            let error = NSError(domain: "Athlete Error", code: 500, userInfo: [NSLocalizedDescriptionKey : "Unable to create Athlete"])
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(athlete: nil, error: error)
            }
        }
    }

}