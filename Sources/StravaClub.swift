//
//  StravaClub.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum ClubResourcePath: String {
    case Club = "/api/v3/clubs/:id"
    case Clubs = "/api/v3/athlete/clubs"
}

public extension Strava {

    /**
     Gets club detail.
     
     ```swift
     Strava.getClub(1) { (club, error) in }
     ```

     Docs: http://strava.github.io/api/v3/clubs/#get-details
     */
    @discardableResult
    static func getClub(_ clubId: Int, completionHandler:((_ club: Club?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = ClubResourcePath.Club.rawValue.replacingOccurrences(of: ":id", with: String(clubId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleClubResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets clubs for current athlete.
     
     ```swift
     Strava.getClubs { (clubs, error) in }
     ```

     Docs: http://strava.github.io/api/v3/clubs/#get-athletes
     */
    @discardableResult
    static func getClubs(_ page: Page? = nil, completionHandler:((_ clubs: [Club]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = ClubResourcePath.Clubs.rawValue

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

            handleClubsResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleClubResponse(_ response: Any?, completionHandler:((_ club: Club?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let club = Club(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(club, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleClubsResponse(_ response: Any?, completionHandler:((_ clubs: [Club]?, _ error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let clubs = Club.clubs(dictionaries)
            DispatchQueue.main.async {
                completionHandler?(clubs, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

}
