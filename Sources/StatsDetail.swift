//
//  StatsDetail.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of stats detail.
 */
public struct StatsDetail {
    public let count: Int
    public let distance: Float
    public let movingTime: Int
    public let elapsedTime: Int
    public let elevationGain: Float

    public let achievementCount: Int?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let count: Int = s.value("count"),
            let distance: Float = s.value("distance"),
            let movingTime: Int = s.value("moving_time"),
            let elapsedTime: Int = s.value("elapsed_time"),
            let elevationGain: Float = s.value("elevation_gain") else {
                return nil
        }

        self.count = count
        self.distance = distance
        self.movingTime = movingTime
        self.elapsedTime = elapsedTime
        self.elevationGain = elevationGain

        // Optional Properties

        self.achievementCount = s.value("achievement_count", required: false)
    }

}
