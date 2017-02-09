//
//  SegmentStats.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of segment stats.
 */
public struct SegmentStats {
    public let prElapsedTime: String?
    public let effortCount: Int

    internal let prDateString: String?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
        let effortCount: Int = s.value("effort_count") {
            self.effortCount = effortCount

            self.prElapsedTime = s.value("pr_elapsed_time", required: false)
            self.prDateString = s.value("pr_date", required: false)
        }
        else {
            return nil
        }
    }

    public var prDate: Date? {
        get {
            return Strava.dateFromString(prDateString)
        }
    }

}
