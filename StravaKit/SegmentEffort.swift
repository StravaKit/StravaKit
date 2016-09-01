//
//  SegmentEffort.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct SegmentEffort {
    let effortId: Int
    let resourceState: Int
    let name: String
    let activity: ResourceSummary
    let athlete: ResourceSummary
    let elapsedTime: Int
    let movingTime: Int
    let startDate: String
    let startDateLocal: String
    let distance: Double
    let startIndex: Int
    let endIndex: Int
    let deviceWatts: Bool
    let averageWatts: Double
    let segment: Segment
    
    let prRank: Int?
    let komRank: Int?

    init?(dictionary: JSONDictionary) {
        if let effortId = dictionary["id"] as? Int,
            let resourceState = dictionary["resource_state"] as? Int,
            let name = dictionary["name"] as? String,
            let activityDictionary = dictionary["activity"] as? JSONDictionary,
            let activity = ResourceSummary(dictionary: activityDictionary),
            let athleteDictionary = dictionary["athlete"] as? JSONDictionary,
            let athlete = ResourceSummary(dictionary: athleteDictionary),
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let movingTime = dictionary["moving_time"] as? Int,
            let startDate = dictionary["start_date"] as? String,
            let startDateLocal = dictionary["start_date_local"] as? String,
            let distance = dictionary["distance"] as? Double,
            let startIndex = dictionary["start_index"] as? Int,
            let endIndex = dictionary["end_index"] as? Int,
            let deviceWatts = dictionary["device_watts"] as? Bool,
            let averageWatts = dictionary["average_watts"] as? Double,
            let segmentDictionary = dictionary["segment"] as? JSONDictionary,
            let segment = Segment(dictionary: segmentDictionary) {
            self.effortId = effortId
            self.resourceState = resourceState
            self.name = name
            self.activity = activity
            self.athlete = athlete
            self.elapsedTime = elapsedTime
            self.movingTime = movingTime
            self.startDate = startDate
            self.startDateLocal = startDateLocal
            self.distance = distance
            self.startIndex = startIndex
            self.endIndex = endIndex
            self.deviceWatts = deviceWatts
            self.averageWatts = averageWatts
            self.segment = segment

            self.prRank = dictionary["pr_rank"] as? Int
            self.komRank = dictionary["kom_rank"] as? Int
        }
        else {
            return nil
        }
    }

    public static func efforts(dictionaries: [JSONDictionary]) -> [SegmentEffort] {
        var efforts: [SegmentEffort] = []
        for dictionary in dictionaries {
            if let effort = SegmentEffort(dictionary: dictionary) {
                efforts.append(effort)
            }
        }

        return efforts
    }

}
