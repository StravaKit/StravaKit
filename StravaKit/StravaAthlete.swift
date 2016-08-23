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
    case Stats = "/api/v3/athletes/:id/stats"
}

public extension Strava {

    // Gets profile for current athlete
    // Docs: http://strava.github.io/api/v3/athlete/#get-details
    static func getAthlete(completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athlete.rawValue

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(athlete: nil, error: error)
                return
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    // Gets profile for athlete by ID
    // Docs: http://strava.github.io/api/v3/athlete/#get-another-details
    static func getAthlete(athleteId: Int, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athletes.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(athlete: nil, error: error)
                return
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    // Gets stats for athlete by ID
    // Docs: http://strava.github.io/api/v3/athlete/#stats
    static func getStats(athleteId: Int, completionHandler: ((stats: Stats?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Stats.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                completionHandler?(stats: nil, error: error)
                return
            }

            handleStatsResponse(athleteId, response: response, completionHandler: completionHandler)
        }

    }

    // MARK: - Internal Functions -

    internal static func handleAthleteResponse(response: AnyObject?, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let athlete = Athlete(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(athlete: athlete, error: nil)
            }
        }
        else {
            let userInfo = [NSLocalizedDescriptionKey : "Unable to create Athlete"]
            let error = NSError(domain: "Athlete Error", code: StravaErrorCode.InvalidResponse.rawValue, userInfo: userInfo)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(athlete: nil, error: error)
            }
        }
    }

    internal static func handleStatsResponse(athleteId: Int, response: AnyObject?, completionHandler: ((stats: Stats?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let stats = Stats(athleteId: athleteId, dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(stats: stats, error: nil)
            }
        }
        else {
            let userInfo = [NSLocalizedDescriptionKey : "Unable to create Stats"]
            let error = NSError(domain: "Stats Error", code: StravaErrorCode.InvalidResponse.rawValue, userInfo: userInfo)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(stats: nil, error: error)
            }
        }
    }

}