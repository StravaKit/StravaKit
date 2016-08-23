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

    init?(dictionary: [String : AnyObject]) {
        if let count = dictionary["count"] as? Int,
            let distance = dictionary["distance"] as? Float,
            let movingTime = dictionary["moving_time"] as? Int,
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let elevationGain = dictionary["elevation_gain"] as? Float {
            let achievementCount = dictionary["achievement_count"] as? Int

            self.count = count
            self.distance = distance
            self.movingTime = movingTime
            self.elapsedTime = elapsedTime
            self.elevationGain = elevationGain
            self.achievementCount = achievementCount
        }
        else {
            return nil
        }

    }

}
