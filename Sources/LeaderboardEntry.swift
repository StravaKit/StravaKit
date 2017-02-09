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
    public let athleteProfileURL: URL

    internal let startDateString: String
    internal let startDateLocalString: String

    public let averageHr: Double?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let athleteName: String = s.value("athlete_name"),
            let athleteId: Int = s.value("athlete_id"),
            let athleteGender: String = s.value("athlete_gender"),
            let averageWatts: Double = s.value("average_watts"),
            let distance: Double = s.value("distance"),
            let elapsedTime: Int = s.value("elapsed_time"),
            let movingTime: Int = s.value("moving_time"),
            let startDate: String = s.value("start_date"),
            let startDateLocal: String = s.value("start_date_local"),
            let activityId: Int = s.value("activity_id"),
            let effortId: Int = s.value("effort_id"),
            let rank: Int = s.value("rank"),
            let neighborhoodIndex: Int = s.value("neighborhood_index"),
            let athleteProfile: String = s.value("athlete_profile"),
            let athleteProfileURL = URL(string: athleteProfile) {
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

            // Optional Properties

            self.averageHr = s.value("average_hr", required: false)
        }
        else {
            return nil
        }
    }

    public var startDate: Date? {
        get {
            return Strava.dateFromString(startDateString)
        }
    }

    public var startDateLocal: Date? {
        get {
            return Strava.dateFromString(startDateLocalString)
        }
    }

}
