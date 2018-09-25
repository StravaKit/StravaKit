//
//  Leaderboard.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a leaderboard.
 */
public struct Leaderboard {
    public let effortCount: Int
    public let entryCount: Int
    public let neighborhoodCount: Int
    public let komType: String
    public let entries: [LeaderboardEntry]

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let effortCount: Int = s.value("effort_count"),
            let entryCount: Int = s.value("entry_count"),
            let neighborhoodCount: Int = s.value("neighborhood_count"),
            let komType: String = s.value("kom_type"),
            let entryDictionaries: JSONArray = s.value("entries") else {
                return nil
        }
        self.effortCount = effortCount
        self.entryCount = entryCount
        self.neighborhoodCount = neighborhoodCount
        self.komType = komType
        self.entries = entryDictionaries.compactMap { (d) in
            return LeaderboardEntry(dictionary: d)
        }
    }
}
