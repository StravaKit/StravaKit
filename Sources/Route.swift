//
//  Route.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/9/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a route.
 */
public struct Route {
    public let routeId: Int
    public let name: String
    public let routeDescription: String
    public let athlete: Athlete
    public let distance: Double
    public let elevationGain: Double
    public let map: Map
    public let isPrivate: Bool
    public let resourceState: Int
    public let starred: Bool
    public let subType: Int
    public let timestamp: Int
    public let type: Int

    let segments: [Segment]?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let routeId: Int = s.value("id"),
            let name: String = s.value("name"),
            let routeDescription: String = s.value("description"),
            let athleteDictionary: JSONDictionary = s.value("athlete"),
            let athlete = Athlete(dictionary: athleteDictionary),
            let distance: Double = s.value("distance"),
            let elevationGain: Double = s.value("elevation_gain"),
            let mapDictionary: JSONDictionary = s.value("map"),
            let map: Map = Map(dictionary: mapDictionary),
            let isPrivate: Bool = s.value("private"),
            let resourceState: Int = s.value("resource_state"),
            let starred: Bool = s.value("starred"),
            let subType: Int = s.value("sub_type"),
            let timestamp: Int = s.value("timestamp"),
            let type: Int = s.value("type") else {
                return nil
        }
        self.routeId = routeId
        self.name = name
        self.routeDescription = routeDescription
        self.athlete = athlete
        self.distance = distance
        self.elevationGain = elevationGain
        self.map = map
        self.isPrivate = isPrivate
        self.resourceState = resourceState
        self.starred = starred
        self.subType = subType
        self.timestamp = timestamp
        self.type = type

        if let segmentsDictionaries: JSONArray = s.value("segments"),
            let segments: [Segment] = Segment.segments(segmentsDictionaries) {
            self.segments = segments
        }
        else {
            self.segments = nil
        }
    }

    /**
     Creates route models from an array of dictionaries.
     */
    public static func routes(_ dictionaries: JSONArray) -> [Route] {
        return dictionaries.compactMap { (d) in
            return Route(dictionary: d)
        }
    }

}
