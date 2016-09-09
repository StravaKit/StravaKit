//
//  Route.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/9/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a club.
 */
public struct Route {
    let routeId: Int
    let name: String
    let routeDescription: String
    let athlete: Athlete
    let distance: Double
    let elevation_gain: Double
    let map: Map
    let isPrivate: Bool
    let resource_state: Int
    let starred: Bool
    let sub_type: Int
    let timestamp: Int
    let type: Int

    let segments: [Segment]?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let routeId: Int = s.value("id"),
            let name: String = s.value("name"),
            let routeDescription: String = s.value("description"),
            let athleteDictionary: JSONDictionary = s.value("athlete"),
            let athlete = Athlete(dictionary: athleteDictionary),
            let distance: Double = s.value("distance"),
            let elevation_gain: Double = s.value("distance"),
            let mapDictionary: JSONDictionary = s.value("map"),
            let map: Map = Map(dictionary: mapDictionary),
            let isPrivate: Bool = s.value("private"),
            let resource_state: Int = s.value("resource_state"),
            let starred: Bool = s.value("starred"),
            let sub_type: Int = s.value("sub_type"),
            let timestamp: Int = s.value("timestamp"),
            let type: Int = s.value("type") {
            self.routeId = routeId
            self.name = name
            self.routeDescription = routeDescription
            self.athlete = athlete
            self.distance = distance
            self.elevation_gain = elevation_gain
            self.map = map
            self.isPrivate = isPrivate
            self.resource_state = resource_state
            self.starred = starred
            self.sub_type = sub_type
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
        else {
            return nil
        }
    }

    /**
     Creates route models from an array of dictionaries.
     */
    public static func routes(dictionaries: JSONArray) -> [Route] {
        var routes: [Route] = []
        for dictionary in dictionaries {
            if let route = Route(dictionary: dictionary) {
                routes.append(route)
            }
        }

        return routes
    }

}
