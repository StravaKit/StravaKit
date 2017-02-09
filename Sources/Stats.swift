//
//  Stats.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of stats.
 */
public struct Stats {
    public let athleteId: Int
    public let biggestRideDistance: Float
    public let biggestClimbElevationGain: Float

    public let recentRideTotals: StatsDetail
    public let recentRunTotals: StatsDetail
    public let recentSwimTotals: StatsDetail

    public let ytdRideTotals: StatsDetail
    public let ytdRunTotals: StatsDetail
    public let ytdSwimTotals: StatsDetail

    public let allRideTotals: StatsDetail
    public let allRunTotals: StatsDetail
    public let allSwimTotals: StatsDetail

    /**
     Failable initializer.
     */
    init?(athleteId: Int, dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let biggestRideDistance: Float = s.value("biggest_ride_distance"),
            let biggestClimbElevationGain: Float = s.value("biggest_climb_elevation_gain"),

            let recentRideTotalsDictionary: JSONDictionary = s.value("recent_ride_totals"),
            let recentRideTotals = StatsDetail(dictionary: recentRideTotalsDictionary),
            let recentRunTotalsDictionary: JSONDictionary = s.value("recent_run_totals"),
            let recentRunTotals = StatsDetail(dictionary: recentRunTotalsDictionary),
            let recentSwimTotalsDictionary: JSONDictionary = s.value("recent_swim_totals"),
            let recentSwimTotals = StatsDetail(dictionary: recentSwimTotalsDictionary),

            let ytdRideTotalsDictionary: JSONDictionary = s.value("ytd_ride_totals"),
            let ytdRideTotals = StatsDetail(dictionary: ytdRideTotalsDictionary),
            let ytdRunTotalsDictionary: JSONDictionary = s.value("ytd_run_totals"),
            let ytdRunTotals = StatsDetail(dictionary: ytdRunTotalsDictionary),
            let ytdSwimTotalsDictionary: JSONDictionary = s.value("ytd_swim_totals"),
            let ytdSwimTotals = StatsDetail(dictionary: ytdSwimTotalsDictionary),

            let allRideTotalsDictionary: JSONDictionary = s.value("all_ride_totals"),
            let allRideTotals = StatsDetail(dictionary: allRideTotalsDictionary),
            let allRunTotalsDictionary: JSONDictionary = s.value("all_run_totals"),
            let allRunTotals = StatsDetail(dictionary: allRunTotalsDictionary),
            let allSwimTotalsDictionary: JSONDictionary = s.value("all_swim_totals"),
            let allSwimTotals = StatsDetail(dictionary: allSwimTotalsDictionary) {
            self.athleteId = athleteId

            self.biggestRideDistance = biggestRideDistance
            self.biggestClimbElevationGain = biggestClimbElevationGain

            self.recentRideTotals = recentRideTotals
            self.recentRunTotals = recentRunTotals
            self.recentSwimTotals = recentSwimTotals

            self.ytdRideTotals = ytdRideTotals
            self.ytdRunTotals = ytdRunTotals
            self.ytdSwimTotals = ytdSwimTotals

            self.allRideTotals = allRideTotals
            self.allRunTotals = allRunTotals
            self.allSwimTotals = allSwimTotals
        }
        else {
            return nil
        }
    }

}
