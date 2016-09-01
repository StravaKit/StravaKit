//
//  Segment.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

public struct Segment {
    let segmentId: Int
    let resourceState: Int
    let name: String
    let distance: Double
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
    let climbCategory: Int
    let starred: Bool

    let isPrivate: Bool?
    let hazardous: Bool?
    let city: String?
    let state: String?
    let country: String?
    let elevationHigh: Double?
    let elevationLow: Double?
    let elevationDifference: Double?
    let climbCategoryDescription: String?
    let maximumGrade: Double?
    let averageGrade: Double?
    let activityType: String?
    let starredDate: String?
    let createdAt: String?
    let updatedAt: String?
    let totalElevationGain: Double?
    let map: Map?
    let effortCount: Int?
    let athleteCount: Int?
    let starCount: Int?
    let athleteSegmentStats: SegmentStats?
    let points: String?

    init?(dictionary: JSONDictionary) {
        if let segmentId = dictionary["id"] as? Int,
            let resourceState = dictionary["resource_state"] as? Int,
            let name = dictionary["name"] as? String,
            let distance = dictionary["distance"] as? Double,
            let start_latlng = dictionary["start_latlng"] as? [Double] where start_latlng.count == 2,
            let end_latlng = dictionary["end_latlng"] as? [Double] where end_latlng.count == 2,
            let startLatitude = start_latlng.first,
            let startLongitude = start_latlng.last,
            let endLatitude = end_latlng.first,
            let endLongitude = end_latlng.last,
            let climbCategory = dictionary["climb_category"] as? Int,
            let starred = dictionary["starred"] as? Bool {
            let startCoordinate = CLLocationCoordinate2DMake(startLatitude, startLongitude)
            let endCoordinate = CLLocationCoordinate2DMake(endLatitude, endLongitude)

            self.segmentId = segmentId
            self.resourceState = resourceState
            self.name = name
            self.distance = distance
            self.startCoordinate = startCoordinate
            self.endCoordinate = endCoordinate
            self.climbCategory = climbCategory
            self.starred = starred

            // Optional properties
            self.points = dictionary["points"] as? String
            self.climbCategoryDescription = dictionary["climb_category_desc"] as? String
            self.elevationHigh = dictionary["elevation_high"] as? Double
            self.elevationLow = dictionary["elevation_low"] as? Double
            self.elevationDifference = dictionary["elev_difference"] as? Double
            self.maximumGrade = dictionary["maximum_grade"] as? Double
            self.averageGrade = dictionary["average_grade"] as? Double
            self.activityType = dictionary["activity_type"] as? String
            self.starredDate = dictionary["starred_date"] as? String
            self.isPrivate = dictionary["private"] as? Bool
            self.hazardous = dictionary["hazardous"] as? Bool
            self.city = dictionary["city"] as? String
            self.state = dictionary["state"] as? String
            self.country = dictionary["country"] as? String
            self.createdAt = dictionary["created_at"] as? String
            self.updatedAt = dictionary["updated_at"] as? String
            self.totalElevationGain = dictionary["total_elevation_gain"] as? Double
            self.map = dictionary["map"] as? Map
            self.effortCount = dictionary["effort_count"] as? Int
            self.athleteCount = dictionary["athlete_count"] as? Int
            self.starCount = dictionary["star_count"] as? Int
            if let statsDictionary = dictionary["athlete_segment_stats"] as? JSONDictionary {
                self.athleteSegmentStats = SegmentStats(dictionary: statsDictionary)
            }
            else {
                self.athleteSegmentStats = nil
            }
        }
        else {
            return nil
        }
    }

    public static func segments(dictionary: JSONDictionary) -> [Segment]? {
        if let dictionaries = dictionary["segments"] as? JSONArray {
            return Segment.segments(dictionaries)
        }
        return nil
    }

    public static func segments(dictionaries: JSONArray) -> [Segment]? {
        var segments: [Segment] = []
        for segmentDictionary in dictionaries {
            if let segment = Segment(dictionary: segmentDictionary) {
                segments.append(segment)
            }
        }
        return segments
    }

    public var coordinates: [CLLocationCoordinate2D]? {
        get {
            if let points = points,
                let coordinates = Polyline.decodePolyline(points) {
                return coordinates
            }
            return nil
        }
    }

}