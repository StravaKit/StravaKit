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

    public static func stats(athleteId: Int, dictionary: [String : AnyObject]) -> Stats? {
        if let biggestRideDistance = dictionary["biggest_ride_distance"] as? Float,
            let biggestClimbElevationGain = dictionary["biggest_climb_elevation_gain"] as? Float,

            let recentRideTotalsDictionary = dictionary["recent_ride_totals"] as? [String : AnyObject],
            let recentRideTotals = StatsDetail.statsDetail(recentRideTotalsDictionary),
            let recentRunTotalsDictionary = dictionary["recent_run_totals"] as? [String : AnyObject],
            let recentRunTotals = StatsDetail.statsDetail(recentRunTotalsDictionary),
            let recentSwimTotalsDictionary = dictionary["recent_swim_totals"] as? [String : AnyObject],
            let recentSwimTotals = StatsDetail.statsDetail(recentSwimTotalsDictionary),

            let ytdRideTotalsDictionary = dictionary["ytd_ride_totals"] as? [String : AnyObject],
            let ytdRideTotals = StatsDetail.statsDetail(ytdRideTotalsDictionary),
            let ytdRunTotalsDictionary = dictionary["ytd_run_totals"] as? [String : AnyObject],
            let ytdRunTotals = StatsDetail.statsDetail(ytdRunTotalsDictionary),
            let ytdSwimTotalsDictionary = dictionary["ytd_swim_totals"] as? [String : AnyObject],
            let ytdSwimTotals = StatsDetail.statsDetail(ytdSwimTotalsDictionary),

            let allRideTotalsDictionary = dictionary["all_ride_totals"] as? [String : AnyObject],
            let allRideTotals = StatsDetail.statsDetail(allRideTotalsDictionary),
            let allRunTotalsDictionary = dictionary["all_run_totals"] as? [String : AnyObject],
            let allRunTotals = StatsDetail.statsDetail(allRunTotalsDictionary),
            let allSwimTotalsDictionary = dictionary["all_swim_totals"] as? [String : AnyObject],
            let allSwimTotals = StatsDetail.statsDetail(allSwimTotalsDictionary) {

            let stats = Stats(athleteId: athleteId, biggestRideDistance: biggestRideDistance, biggestClimbElevationGain: biggestClimbElevationGain, recentRideTotals: recentRideTotals, recentRunTotals: recentRunTotals, recentSwimTotals: recentSwimTotals, ytdRideTotals: ytdRideTotals, ytdRunTotals: ytdRunTotals, ytdSwimTotals: ytdSwimTotals, allRideTotals: allRideTotals, allRunTotals: allRunTotals, allSwimTotals: allSwimTotals)
            
            return stats
        }
        
        return nil
    }
    
}
