//
//  LeaderboardEntry.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a leaderboard entry.
 */
public struct LeaderboardEntry {
    public let athleteName: String
    public let athleteId: Int
    public let athleteGender: String
    public let averageWatts: Double
    public let distance: Double
    public let elapsedTime: Int
    public let movingTime: Int
    public let activityId: Int
    public let effortId: Int
    public let rank: Int
    public let neighborhoodIndex: Int
    public let athleteProfileURL: NSURL

    internal let startDateString: String
    internal let startDateLocalString: String

    public let averageHr: Double?

    /**
     Failable initializer.
     */
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
            self.startDateString = startDate
            self.startDateLocalString = startDateLocal
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

    public var startDate: NSDate? {
        get {
            return Strava.dateFromString(startDateString)
        }
    }

    public var startDateLocal: NSDate? {
        get {
            return Strava.dateFromString(startDateLocalString)
        }
    }
    
}
