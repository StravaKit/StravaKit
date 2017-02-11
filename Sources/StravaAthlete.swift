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
    case Zones = "/api/v3/athlete/zones"
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
    @discardableResult
    static func getAthlete(_ completionHandler: ((_ athlete: Athlete?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = AthleteResourcePath.Athlete.rawValue

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
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
    @discardableResult
    static func getAthlete(_ athleteId: Int, completionHandler: ((_ athlete: Athlete?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = AthleteResourcePath.Athletes.rawValue.replacingOccurrences(of: ":id", with: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleAthleteResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets friends of current athlete.

     ```swift
     Strava.getAthleteFriends { (athletes, error) in }
     ```

     Docs: http://strava.github.io/api/v3/follow/#friends
     */
    @discardableResult
    static func getAthleteFriends(_ page: Page? = nil, completionHandler: ((_ athletes: [Athlete]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
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
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleAthleteFriendsResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets zones of current athlete.

     ```swift
     Strava.getAthleteZones { (zones, error) in }
     ```

     Docs: http://strava.github.io/api/v3/athlete/#zones
     */
    @discardableResult
    static func getAthleteZones(_ page: Page? = nil, completionHandler: ((_ zones: Zones?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = AthleteResourcePath.Zones.rawValue

        var params: ParamsDictionary? = nil
        if let page = page {
            params = [
                PageKey: page.page,
                PerPageKey: page.perPage
            ]
        }

        return request(.GET, authenticated: true, path: path, params: params) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleAthleteZonesResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets stats for athlete by ID.

     ```swift
     Strava.getStats(athleteId, completionHandler: { (stats, error) in }
     ```

     Docs: http://strava.github.io/api/v3/athlete/#stats
     */
    @discardableResult
    static func getStats(_ athleteId: Int, completionHandler: ((_ stats: Stats?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = AthleteResourcePath.Stats.rawValue.replacingOccurrences(of: ":id", with: String(athleteId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleStatsResponse(athleteId, response: response, completionHandler: completionHandler)
        }

    }

    // MARK: - Internal Functions -

    internal static func handleAthleteResponse(_ response: Any?, completionHandler: ((_ athlete: Athlete?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let athlete = Athlete(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(athlete, nil)
            }
        }
        else {
            let error = Strava.error(.invalidResponse, reason: "Invalid Response")
            DispatchQueue.main.async {
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleAthleteFriendsResponse(_ response: Any?, completionHandler: ((_ athletes: [Athlete]?, _ error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let athletes = Athlete.athletes(dictionaries)
            DispatchQueue.main.async {
                completionHandler?(athletes, nil)
            }
        }
        else {
            let error = Strava.error(.invalidResponse, reason: "Invalid Response")
            DispatchQueue.main.async {
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleAthleteZonesResponse(_ response: Any?, completionHandler: ((_ zones: Zones?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let zones = Zones(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(zones, nil)
            }
        }
        else {
            let error = Strava.error(.invalidResponse, reason: "Invalid Response")
            DispatchQueue.main.async {
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleStatsResponse(_ athleteId: Int, response: Any?, completionHandler: ((_ stats: Stats?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let stats = Stats(athleteId: athleteId, dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(stats, nil)
            }
        }
        else {
            let error = Strava.error(.invalidResponse, reason: "Invalid Response")
            DispatchQueue.main.async {
                completionHandler?(nil, error)
            }
        }
    }

}
