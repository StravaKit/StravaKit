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
    case Friends = "/api/v3/athlete/friends"
    case Stats = "/api/v3/athletes/:id/stats"
}

public extension Strava {

    /**
     Gets profile for current athlete.
     
     ```swift
     Strava.getAthlete { (athlete, error) in }
     ```

     Docs: http://strava.github.io/api/v3/athlete/#get-details
     */
    static func getAthlete(completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athlete.rawValue

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(athlete: nil, error: error)
                }
                return
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets profile for athlete by ID.

     ```swift
     Strava.getAthlete(athleteId) { (athlete, error) in }
     ```

     Docs: http://strava.github.io/api/v3/athlete/#get-another-details
     */
    static func getAthlete(athleteId: Int, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Athletes.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(athlete: nil, error: error)
                }
                return
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets stats for athlete by ID.

     ```swift
     Strava.getStats(athleteId, completionHandler: { (stats, error) in }
     ```

     Docs: http://strava.github.io/api/v3/athlete/#stats
     */
    static func getStats(athleteId: Int, completionHandler: ((stats: Stats?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Stats.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(stats: nil, error: error)
                }
                return
            }

            handleStatsResponse(athleteId, response: response, completionHandler: completionHandler)
        }

    }

    /**
     Gets friends of current athlete.
     
     ```swift
     Strava.getAthleteFriends { (athletes, error) in }
     ```

     Docs: http://strava.github.io/api/v3/follow/#friends
     */
    static func getAthleteFriends(page: Page? = nil, completionHandler: ((athletes: [Athlete]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = AthleteResourcePath.Friends.rawValue

        var params: ParamsDictionary? = nil
        if let page = page {
            params = [
                PageKey: page.page,
                PerPageKey: page.perPage
            ]
        }

        return request(.GET, authenticated: true, path: path, params: params) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(athletes: nil, error: error)
                }
                return
            }

            handleAthleteFriendsResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleAthleteFriendsResponse(response: AnyObject?, completionHandler: ((athletes: [Athlete]?, error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let athletes = Athlete.athletes(dictionaries)
            dispatch_async(dispatch_get_main_queue()) {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(athletes: athletes, error: nil)
                }
            }
        }
        else {
            let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(athletes: nil, error: error)
            }
        }
    }

    internal static func handleAthleteResponse(response: AnyObject?, completionHandler: ((athlete: Athlete?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let athlete = Athlete(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(athlete: athlete, error: nil)
                }
            }
        }
        else {
            let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
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
            let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(stats: nil, error: error)
            }
        }
    }
    
}