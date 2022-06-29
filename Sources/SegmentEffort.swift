//
//  SegmentEffort.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a segment effort.
 */
public struct SegmentEffort {
    public let effortId: Int
    public let resourceState: Int
    public let name: String
    public let activity: ResourceSummary
    public let athlete: ResourceSummary
    public let elapsedTime: Int
    public let movingTime: Int
    public let distance: Double
    public let startIndex: Int
    public let endIndex: Int
    public let deviceWatts: Bool
    public let averageWatts: Double
    public let segment: Segment

    public let prRank: Int?
    public let komRank: Int?

    internal let startDateString: String
    internal let startDateLocalString: String

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let effortId: Int = s.value("id"),
            let resourceState: Int = s.value("resource_state"),
            let name: String = s.value("name"),
            let activityDictionary: JSONDictionary = s.value("activity"),
            let activity = ResourceSummary(dictionary: activityDictionary),
            let athleteDictionary: JSONDictionary = s.value("athlete"),
            let athlete = ResourceSummary(dictionary: athleteDictionary),
            let elapsedTime: Int = s.value("elapsed_time"),
            let movingTime: Int = s.value("moving_time"),
            let startDate: String = s.value("start_date"),
            let startDateLocal: String = s.value("start_date_local"),
            let distance: Double = s.value("distance"),
            let startIndex: Int = s.value("start_index"),
            let endIndex: Int = s.value("end_index"),
            let deviceWatts: Bool = s.value("device_watts"),
            let averageWatts: Double = s.value("average_watts"),
            let segmentDictionary: JSONDictionary = s.value("segment"),
            let segment = Segment(dictionary: segmentDictionary) else {
                return nil
        }
        self.effortId = effortId
        self.resourceState = resourceState
        self.name = name
        self.activity = activity
        self.athlete = athlete
        self.elapsedTime = elapsedTime
        self.movingTime = movingTime
        self.startDateString = startDate
        self.startDateLocalString = startDateLocal
        self.distance = distance
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.deviceWatts = deviceWatts
        self.averageWatts = averageWatts
        self.segment = segment

        self.prRank = s.value("pr_rank", required: false)
        self.komRank = s.value("kom_rank", required: false)
    }

    public static func efforts(_ dictionaries: [JSONDictionary]) -> [SegmentEffort] {
        return dictionaries.compactMap { (d) in
            return SegmentEffort(dictionary: d)
        }
    }

    public var startDate: Date? {
        return Strava.dateFromString(startDateString)
    }

    public var startDateLocal: Date? {
        return Strava.dateFromString(startDateLocalString)
    }

}
