//
//  StravaClub.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum ClubResourcePath: String {
    case Club = "/v3/clubs/:id"
    case Clubs = "/api/v3/athlete/clubs"
}

public extension Strava {

    // Gets club detail
    // Docs: http://strava.github.io/api/v3/clubs/#get-details
    static func getClub(clubId: Int, completionHandler:((club: Club?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = ClubResourcePath.Club.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(clubId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(club: nil, error: error)
                }
                return
            }

            handleClubResponse(response, completionHandler: completionHandler)
        }
    }

    // Gets clubs for current athlete
    // Docs: http://strava.github.io/api/v3/clubs/#get-athletes
    static func getClubs(completionHandler:((clubs: [Club]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = ClubResourcePath.Clubs.rawValue

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(clubs: nil, error: error)
                }
                return
            }

            handleClubsResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleClubResponse(response: AnyObject?, completionHandler:((club: Club?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let club = Club(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(club: club, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(club: nil, error: error)
            }
        }
    }

    internal static func handleClubsResponse(response: AnyObject?, completionHandler:((clubs: [Club]?, error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            var clubs: [Club] = []
            for dictionary in dictionaries {
                if let club = Club(dictionary: dictionary) {
                    clubs.append(club)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(clubs: clubs, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(clubs: nil, error: error)
            }
        }
    }

}
