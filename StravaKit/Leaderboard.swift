//
//  Leaderboard.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct Leaderboard {
    public let effortCount: Int
    public let entryCount: Int
    public let neighborhoodCount: Int
    public let komType: String
    public let entries: [LeaderboardEntry]

    init?(dictionary: JSONDictionary) {
        if let effortCount = dictionary["effort_count"] as? Int,
        let entryCount = dictionary["entry_count"] as? Int,
        let neighborhoodCount = dictionary["neighborhood_count"] as? Int,
        let komType = dictionary["kom_type"] as? String,
        let entryDictionaries = dictionary["entries"] as? JSONArray {
            self.effortCount = effortCount
            self.entryCount = entryCount
            self.neighborhoodCount = neighborhoodCount
            self.komType = komType
            var entries: [LeaderboardEntry] = []
            for entryDictionary in entryDictionaries {
                if let entry = LeaderboardEntry(dictionary: entryDictionary) {
                    entries.append(entry)
                }
            }
            self.entries = entries
        }
        else {
            return nil
        }
    }
}
