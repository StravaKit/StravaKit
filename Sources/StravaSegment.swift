//
//  StravaSegment.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum SegmentResourcePath: String {
    case Segment = "/api/v3/segments/:id"
    case Segments = "/api/v3/segments/explore"
    case StarredSegments = "/api/v3/segments/starred"
    case Leaderboard = "/api/v3/segments/:id/leaderboard"
    case AllEfforts = "/api/v3/segments/:id/all_efforts"
}

public extension Strava {

    /**
     Gets a segment detail.
     
     ```swift
     Strava.getSegment(1) { (segment, error) in }
     ```

     Docs: http://strava.github.io/api/v3/segments/#retrieve
     */
    @discardableResult
    public static func getSegment(_ segmentId: Int, completionHandler:((_ segment: Segment?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = SegmentResourcePath.Segment.rawValue.replacingOccurrences(of: ":id", with: String(segmentId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleSegmentResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets segments for a given map bounds.

     ```swift
     Strava.getSegments(mapBounds) { (segments, error) in }
     ```

     Docs: http://strava.github.io/api/v3/segments/#explore
     */
    @discardableResult
    public static func getSegments(_ mapBounds: MapBounds, page: Page? = nil, completionHandler:((_ segments: [Segment]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = SegmentResourcePath.Segments.rawValue
        var params: ParamsDictionary = [
            "bounds" : "\(mapBounds.coordinate1.latitude),\(mapBounds.coordinate1.longitude),\(mapBounds.coordinate2.latitude),\(mapBounds.coordinate2.longitude)"
        ]

        if let page = page {
            params[PageKey] = page.page
            params[PerPageKey] = page.perPage
        }

        return request(.GET, authenticated: true, path: path, params: params) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleSegmentsResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets starred segments for current athlete.

     ```swift
     Strava.getStarredSegments() { (segments, error) in }
     ```

     Docs: http://strava.github.io/api/v3/segments/#starred
     */
    @discardableResult
    public static func getStarredSegments(_ page: Page? = nil, completionHandler:((_ segments: [Segment]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = SegmentResourcePath.StarredSegments.rawValue

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

            handleStarredSegmentsResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets leaderboard segments.
     
     ```swift
     Strava.getSegmentLeaderboard(1) { (leaderboard, error) in }
     ```

     Docs: http://strava.github.io/api/v3/segments/#leaderboard
     */
    @discardableResult
    public static func getSegmentLeaderboard(_ segmentId: Int, page: Page? = nil, completionHandler:((_ leaderboard: Leaderboard?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = SegmentResourcePath.Leaderboard.rawValue.replacingOccurrences(of: ":id", with: String(segmentId))

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

            handleSegmentLeaderboardResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets all efforts for a segment.

     ```swift
     getSegmentEfforts(1) { (efforts, error) in }
     ```

     Docs: http://strava.github.io/api/v3/segments/#efforts
     */
    @discardableResult
    public static func getSegmentEfforts(_ segmentId: Int, page: Page? = nil, completionHandler:((_ efforts: [SegmentEffort]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = SegmentResourcePath.AllEfforts.rawValue.replacingOccurrences(of: ":id", with: String(segmentId))

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

            handleSegmentEffortsResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleSegmentResponse(_ response: Any?, completionHandler:((_ segment: Segment?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let segment = Segment(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(segment, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleSegmentsResponse(_ response: Any?, completionHandler:((_ segments: [Segment]?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary {
            let segments = Segment.segments(dictionary)
            DispatchQueue.main.async {
                completionHandler?(segments, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleStarredSegmentsResponse(_ response: Any?, completionHandler:((_ segments: [Segment]?, _ error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let segments = Segment.segments(dictionaries)
            DispatchQueue.main.async {
                completionHandler?(segments, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleSegmentLeaderboardResponse(_ response: Any?, completionHandler:((_ leaderboard: Leaderboard?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let leaderboard = Leaderboard(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(leaderboard, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleSegmentEffortsResponse(_ response: Any?, completionHandler:((_ efforts: [SegmentEffort]?, _ error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let efforts = SegmentEffort.efforts(dictionaries)
            DispatchQueue.main.async {
                completionHandler?(efforts, nil)
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
