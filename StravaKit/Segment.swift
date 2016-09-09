//
//  Segment.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/30/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Model Representation of a segment.
 */
public struct Segment {
    public let segmentId: Int
    public let resourceState: Int
    public let name: String
    public let distance: Double
    public let startCoordinate: CLLocationCoordinate2D
    public let endCoordinate: CLLocationCoordinate2D
    public let climbCategory: Int
    public let starred: Bool

    public let isPrivate: Bool?
    public let hazardous: Bool?
    public let city: String?
    public let state: String?
    public let country: String?
    public let elevationHigh: Double?
    public let elevationLow: Double?
    public let elevationDifference: Double?
    public let climbCategoryDescription: String?
    public let maximumGrade: Double?
    public let averageGrade: Double?
    public let activityType: String?
    public let starredDateString: String?
    public let createdAtString: String?
    public let updatedAtString: String?
    public let totalElevationGain: Double?
    public let map: Map?
    public let effortCount: Int?
    public let athleteCount: Int?
    public let starCount: Int?
    public let athleteSegmentStats: SegmentStats?
    public let points: String?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let segmentId: Int = s.value("id"),
            let resourceState: Int = s.value("resource_state"),
            let name: String = s.value("name"),
            let distance: Double = s.value("distance"),
            let start_latlng: [Double] = s.value("start_latlng") where start_latlng.count == 2,
            let end_latlng: [Double] = s.value("end_latlng") where end_latlng.count == 2,
            let startLatitude: Double = start_latlng.first,
            let startLongitude: Double = start_latlng.last,
            let endLatitude: Double = end_latlng.first,
            let endLongitude: Double = end_latlng.last,
            let climbCategory: Int = s.value("climb_category"),
            let starred: Bool = s.value("starred") {
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

            // Optional Properties

            self.points = s.value("points")
            self.climbCategoryDescription = s.value("climb_category_desc")
            self.elevationHigh = s.value("elevation_high")
            self.elevationLow = s.value("elevation_low")
            self.elevationDifference = s.value("elev_difference")
            self.maximumGrade = s.value("maximum_grade")
            self.averageGrade = s.value("average_grade")
            self.activityType = s.value("activity_type")
            self.starredDateString = s.value("starred_date")
            self.isPrivate = s.value("private")
            self.hazardous = s.value("hazardous")
            self.city = s.value("city")
            self.state = s.value("state")
            self.country = s.value("country")
            self.createdAtString = s.value("created_at")
            self.updatedAtString = s.value("updated_at")
            self.totalElevationGain = s.value("total_elevation_gain")
            self.map = s.value("map")
            self.effortCount = s.value("effort_count")
            self.athleteCount = s.value("athlete_count")
            self.starCount = s.value("star_count")
            if let statsDictionary: JSONDictionary = s.value("athlete_segment_stats") {
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
        if let s = JSONSupport(dictionary: dictionary),
        let dictionaries: JSONArray = s.value("segments")  {
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

    public var starredDate: NSDate? {
        get {
            return Strava.dateFromString(starredDateString)
        }
    }

    public var createdAt: NSDate? {
        get {
            return Strava.dateFromString(createdAtString)
        }
    }

    public var updatedAt: NSDate? {
        get {
            return Strava.dateFromString(updatedAtString)
        }
    }
    
}