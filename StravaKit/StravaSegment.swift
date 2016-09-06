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

     Docs: http://strava.github.io/api/v3/segments/#retrieve
     */
    static func getSegment(segmentId: Int, completionHandler:((segment: Segment?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = SegmentResourcePath.Segment.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(segmentId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(segment: nil, error: error)
                }
                return
            }

            handleSegmentResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets segments for a given map bounds.

     Docs: http://strava.github.io/api/v3/segments/#explore
     */
    static func getSegments(mapBounds: MapBounds, page: Page? = nil, completionHandler:((segments: [Segment]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
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
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(segments: nil, error: error)
                }
                return
            }

            handleSegmentsResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets starred segments for current athlete.

     Docs: http://strava.github.io/api/v3/segments/#starred
     */
    static func getStarredSegments(page: Page? = nil, completionHandler:((segments: [Segment]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
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
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(segments: nil, error: error)
                }
                return
            }

            handleStarredSegmentsResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets leaderboard segments.

     Docs: http://strava.github.io/api/v3/segments/#leaderboard
     */
    static func getSegmentLeaderboard(segmentId: Int, page: Page? = nil, completionHandler:((leaderboard: Leaderboard?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = SegmentResourcePath.Leaderboard.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(segmentId))

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
                    completionHandler?(leaderboard: nil, error: error)
                }
                return
            }

            handleSegmentLeaderboardResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets all efforts for a segment.

     Docs: http://strava.github.io/api/v3/segments/#efforts
     */
    static func getSegmentEfforts(segmentId: Int, page: Page? = nil, completionHandler:((efforts: [SegmentEffort]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = SegmentResourcePath.AllEfforts.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(segmentId))

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
                    completionHandler?(efforts: nil, error: error)
                }
                return
            }

            handleSegmentEffortsResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleSegmentResponse(response: AnyObject?, completionHandler:((segment: Segment?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let segment = Segment(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(segment: segment, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(segment: nil, error: error)
            }
        }
    }

    internal static func handleSegmentsResponse(response: AnyObject?, completionHandler:((segments: [Segment]?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary {
            let segments = Segment.segments(dictionary)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(segments: segments, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(segments: nil, error: error)
            }
        }
    }

    internal static func handleStarredSegmentsResponse(response: AnyObject?, completionHandler:((segments: [Segment]?, error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let segments = Segment.segments(dictionaries)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(segments: segments, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(segments: nil, error: error)
            }
        }
    }

    internal static func handleSegmentLeaderboardResponse(response: AnyObject?, completionHandler:((leaderboard: Leaderboard?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let leaderboard = Leaderboard(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(leaderboard: leaderboard, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(leaderboard: nil, error: error)
            }
        }
    }

    internal static func handleSegmentEffortsResponse(response: AnyObject?, completionHandler:((efforts: [SegmentEffort]?, error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let efforts = SegmentEffort.efforts(dictionaries)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(efforts: efforts, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(efforts: nil, error: error)
            }
        }
    }
    
}
