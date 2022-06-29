//
//  StravaActivity.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public enum ActivityResourcePath: String {
    case Activities = "/api/v3/athlete/activities"
    case Activity = "/api/v3/activities/:id"
    case Following = "/api/v3/activities/following"
}

public extension Strava {

    /**
     Gets activities for current athlete.

     ```swift
     Strava.getActivities { (activities, error) in }
     ```

     Docs: http://strava.github.io/api/v3/activities/#get-activities
     */
    @discardableResult
    public static func getActivities(_ page: Page? = nil, completionHandler:((_ activities: [Activity]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = ActivityResourcePath.Activities.rawValue

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

            handleActivitiesResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets activity detail.
     
     ```swift
     Strava.getActivity(firstActivity.activityId, completionHandler: { (activity, error) in }
     ```

     Docs: http://strava.github.io/api/v3/activities/#get-details
     */
    @discardableResult
    public static func getActivity(_ activityId: Int, completionHandler:((_ activity: Activity?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = replaceId(id: activityId, in: ActivityResourcePath.Activity.rawValue)

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleActivityResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets following activities (friends).
     
     ```swift
     Strava.getFollowingActivities { (activities, error) in }
     ```

     Docs: http://strava.github.io/api/v3/activities/#get-feed
     */
    @discardableResult
    public static func getFollowingActivities(_ page: Page? = nil, completionHandler:((_ activities: [Activity]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = ActivityResourcePath.Following.rawValue

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

            handleActivitiesResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleActivitiesResponse(_ response: Any?, completionHandler: ((_ activities: [Activity]?, _ error: NSError?) -> ())?) {
        let activities = (response as? JSONArray)?.compactMap { (d) in
            return Activity(dictionary: d)
        }
        DispatchQueue.main.async {
            completionHandler?(activities ?? [], nil)
        }
    }

    internal static func handleActivityResponse(_ response: Any?, completionHandler:((_ activity: Activity?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let activity = Activity(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(activity, nil)
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
