//
//  StatsDetail.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct StatsDetail {
    public let count: Int
    public let distance: Float
    public let movingTime: Int
    public let elapsedTime: Int
    public let elevationGain: Float
    public let achievementCount: Int?

    public static func statsDetail(dictionary: [String : AnyObject]) -> StatsDetail? {
        if let count = dictionary["count"] as? Int,
            let distance = dictionary["distance"] as? Float,
            let movingTime = dictionary["moving_time"] as? Int,
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let elevationGain = dictionary["elevation_gain"] as? Float {
            let achievementCount = dictionary["achievement_count"] as? Int

            let statsDetail = StatsDetail(count: count, distance: distance, movingTime: movingTime, elapsedTime: elapsedTime, elevationGain: elevationGain, achievementCount: achievementCount)

            return statsDetail
        }
        
        return nil
    }
    
}
