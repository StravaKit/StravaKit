//
//  Stats.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

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

    init?(athleteId: Int, dictionary: JSONDictionary) {
        if let biggestRideDistance = dictionary["biggest_ride_distance"] as? Float,
            let biggestClimbElevationGain = dictionary["biggest_climb_elevation_gain"] as? Float,

            let recentRideTotalsDictionary = dictionary["recent_ride_totals"] as? JSONDictionary,
            let recentRideTotals = StatsDetail(dictionary: recentRideTotalsDictionary),
            let recentRunTotalsDictionary = dictionary["recent_run_totals"] as? JSONDictionary,
            let recentRunTotals = StatsDetail(dictionary: recentRunTotalsDictionary),
            let recentSwimTotalsDictionary = dictionary["recent_swim_totals"] as? JSONDictionary,
            let recentSwimTotals = StatsDetail(dictionary: recentSwimTotalsDictionary),

            let ytdRideTotalsDictionary = dictionary["ytd_ride_totals"] as? JSONDictionary,
            let ytdRideTotals = StatsDetail(dictionary: ytdRideTotalsDictionary),
            let ytdRunTotalsDictionary = dictionary["ytd_run_totals"] as? JSONDictionary,
            let ytdRunTotals = StatsDetail(dictionary: ytdRunTotalsDictionary),
            let ytdSwimTotalsDictionary = dictionary["ytd_swim_totals"] as? JSONDictionary,
            let ytdSwimTotals = StatsDetail(dictionary: ytdSwimTotalsDictionary),

            let allRideTotalsDictionary = dictionary["all_ride_totals"] as? JSONDictionary,
            let allRideTotals = StatsDetail(dictionary: allRideTotalsDictionary),
            let allRunTotalsDictionary = dictionary["all_run_totals"] as? JSONDictionary,
            let allRunTotals = StatsDetail(dictionary: allRunTotalsDictionary),
            let allSwimTotalsDictionary = dictionary["all_swim_totals"] as? JSONDictionary,
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
