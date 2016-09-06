//
//  SegmentStats.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct SegmentStats {
    public let prElapsedTime: String?
    public let effortCount: Int

    internal let prDateString: String?

    init?(dictionary: JSONDictionary) {
        if let effortCount = dictionary["effort_count"] as? Int {
            self.effortCount = effortCount

            self.prElapsedTime = dictionary["pr_elapsed_time"] as? String
            self.prDateString = dictionary["pr_date"] as? String
        }
        else {
            return nil
        }
    }

    public var prDate: NSDate? {
        get {
            return Strava.dateFromString(prDateString)
        }
    }

}
