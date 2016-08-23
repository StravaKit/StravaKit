//
//  Activity.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

public struct Activity {
    public let activityId: Int
    public let externalId: String
    public let uploadId: Int
    public let athleteId: Int
    public let athleteResourceState: Int
    public let name: String
    public let distance: Float
    public let movingTime: Int
    public let elapsedTime: Int

    public let totalElevationGain: Float
    public let type: String
    public let startDate: String
    public let startDateLocal: String
    public let timezone: String
    public let startCoordinates: [CLLocationDegrees]
    public let endCoordinates: [CLLocationDegrees]
    public let city: String
    public let state: String
    public let country: String
    public let achievementCount: Int
    public let kudosCount: Int
    public let commentCount: Int
    public let athleteCount: Int
    public let photoCount: Int
    public let mapId: String
    public let mapSummaryPolyline: String
    public let mapResourceState: Int
    public let trainer: Bool
    public let commute: Bool
    public let manual: Bool
    public let privateActivity: Bool
    public let flagged: Bool
    public let gearId: Int?
    public let averageSpeed: Float
    public let maxSpeed: Float
    public let averageWatts: Float
    public let kilojoules: Float
    public let deviceWatts: Bool
    public let hasHeartrate: Bool
    public let elevationHigh: Float
    public let elevationLow: Float
    public let totalPhotoCount: Int
    public let hasKudoed: Bool
    public let workoutType: Int

    init?(dictionary: JSONDictionary) {
        if let activityId = dictionary["id"] as? Int,
            let externalId = dictionary["external_id"] as? String,
            let uploadId = dictionary["upload_id"] as? Int,
            let athleteDictionary = dictionary["athlete"] as? JSONDictionary,
            let athleteId = athleteDictionary["id"] as? Int,
            let athleteResourceState = athleteDictionary["resource_state"] as? Int,
            let name = dictionary["name"] as? String,
            let distance = dictionary["distance"] as? Float,
            let movingTime = dictionary["moving_time"] as? Int,
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let totalElevationGain = dictionary["total_elevation_gain"] as? Float,
            let type = dictionary["type"] as? String,
            let startDate = dictionary["start_date"] as? String,
            let startDateLocal = dictionary["start_date_local"] as? String,
            let timezone = dictionary["timezone"] as? String,
            let startCoordinates = dictionary["start_latlng"] as? [CLLocationDegrees] where startCoordinates.count == 2,
            let endCoordinates = dictionary["end_latlng"] as? [CLLocationDegrees] where endCoordinates.count == 2,
            let city = dictionary["location_city"] as? String,
            let state = dictionary["location_state"] as? String,
            let country = dictionary["location_country"] as? String,
            let achievementCount = dictionary["achievement_count"] as? Int,
            let kudosCount = dictionary["kudos_count"] as? Int,
            let commentCount = dictionary["comment_count"] as? Int,
            let athleteCount = dictionary["athlete_count"] as? Int,
            let photoCount = dictionary["photo_count"] as? Int,
            let mapDictionary = dictionary["map"] as? JSONDictionary,
            let mapId = mapDictionary["id"] as? String,
            let mapSummaryPolyline = mapDictionary["summary_polyline"] as? String,
            let mapResourceState = mapDictionary["resource_state"] as? Int,
            let trainer = dictionary["trainer"] as? Bool,
            let commute = dictionary["commute"] as? Bool,
            let manual = dictionary["manual"] as? Bool,
            let privateActivity = dictionary["private"] as? Bool,
            let flagged = dictionary["flagged"] as? Bool,
            let averageSpeed = dictionary["average_speed"] as? Float,
            let maxSpeed = dictionary["max_speed"] as? Float,
            let averageWatts = dictionary["average_watts"] as? Float,
            let kilojoules = dictionary["kilojoules"] as? Float,
            let deviceWatts = dictionary["device_watts"] as? Bool,
            let hasHeartrate = dictionary["has_heartrate"] as? Bool,
            let elevationHigh = dictionary["elev_high"] as? Float,
            let elevationLow = dictionary["elev_low"] as? Float,
            let totalPhotoCount = dictionary["total_photo_count"] as? Int,
            let hasKudoed = dictionary["has_kudoed"] as? Bool,
            let workoutType = dictionary["workout_type"] as? Int {
            self.activityId = activityId
            self.externalId = externalId
            self.uploadId = uploadId
            self.athleteId = athleteId
            self.athleteResourceState = athleteResourceState
            self.name = name
            self.distance = distance
            self.movingTime = movingTime
            self.elapsedTime = elapsedTime
            self.totalElevationGain = totalElevationGain
            self.type = type
            self.startDate = startDate
            self.startDateLocal = startDateLocal
            self.timezone = timezone
            self.startCoordinates = startCoordinates
            self.endCoordinates = endCoordinates
            self.city = city
            self.state = state
            self.country = country
            self.achievementCount = achievementCount
            self.kudosCount = kudosCount
            self.commentCount = commentCount
            self.athleteCount = athleteCount
            self.photoCount = photoCount
            self.mapId = mapId
            self.mapSummaryPolyline = mapSummaryPolyline
            self.mapResourceState = mapResourceState
            self.trainer = trainer
            self.commute = commute
            self.manual = manual
            self.privateActivity = privateActivity
            self.flagged = flagged
            self.gearId = dictionary["gear_id"] as? Int
            self.averageSpeed = averageSpeed
            self.maxSpeed = maxSpeed
            self.averageWatts = averageWatts
            self.kilojoules = kilojoules
            self.deviceWatts = deviceWatts
            self.hasHeartrate = hasHeartrate
            self.elevationHigh = elevationHigh
            self.elevationLow = elevationLow
            self.totalPhotoCount = totalPhotoCount
            self.hasKudoed = hasKudoed
            self.workoutType = workoutType
        }
        else {
            return nil
        }
    }

    public static func activities(dictionaries: [JSONDictionary]) -> [Activity]? {
        var activities: [Activity] = []
        for dictionary in dictionaries {
            if let activity = Activity(dictionary: dictionary) {
                activities.append(activity)
            }
        }

        if activities.count > 0 {
            return activities
        }

        return nil
    }

    public var startCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.startCoordinates.first!, startCoordinates.last!)
        }
    }

    public var endCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.endCoordinates.first!, endCoordinates.last!)
        }
    }

}
