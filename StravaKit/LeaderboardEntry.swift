//
//  LeaderboardEntry.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct LeaderboardEntry {
    let athleteName: String
    let athleteId: Int
    let athleteGender: String
    let averageWatts: Double
    let distance: Double
    let elapsedTime: Int
    let movingTime: Int
    let startDate: String
    let startDateLocal: String
    let activityId: Int
    let effortId: Int
    let rank: Int
    let neighborhoodIndex: Int
    let athleteProfileURL: NSURL

    let averageHr: Double?

    init?(dictionary: JSONDictionary) {
        if let athleteName = dictionary["athlete_name"] as? String,
            let athleteId = dictionary["athlete_id"] as? Int,
            let athleteGender = dictionary["athlete_gender"] as? String,
            let averageWatts = dictionary["average_watts"] as? Double,
            let distance = dictionary["distance"] as? Double,
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let movingTime = dictionary["moving_time"] as? Int,
            let startDate = dictionary["start_date"] as? String,
            let startDateLocal = dictionary["start_date_local"] as? String,
            let activityId = dictionary["activity_id"] as? Int,
            let effortId = dictionary["effort_id"] as? Int,
            let rank = dictionary["rank"] as? Int,
            let neighborhoodIndex = dictionary["neighborhood_index"] as? Int,
            let athleteProfile = dictionary["athlete_profile"] as? String,
            let athleteProfileURL = NSURL(string: athleteProfile) {
            self.athleteName = athleteName
            self.athleteId = athleteId
            self.athleteGender = athleteGender
            self.averageWatts = averageWatts
            self.distance = distance
            self.elapsedTime = elapsedTime
            self.movingTime = movingTime
            self.startDate = startDate
            self.startDateLocal = startDateLocal
            self.activityId = activityId
            self.effortId = effortId
            self.rank = rank
            self.neighborhoodIndex = neighborhoodIndex
            self.athleteProfileURL = athleteProfileURL

            self.averageHr = dictionary["average_hr"] as? Double
        }
        else {
            return nil
        }
    }
}
