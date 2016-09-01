//
//  SegmentStats.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct SegmentStats {
    let prElapsedTime: String?
    let prDate: String?
    let effortCount: Int

    init?(dictionary: JSONDictionary) {
        if let effortCount = dictionary["effort_count"] as? Int {
            self.effortCount = effortCount

            self.prElapsedTime = dictionary["pr_elapsed_time"] as? String
            self.prDate = dictionary["pr_date"] as? String
        }
        else {
            return nil
        }
    }
}
