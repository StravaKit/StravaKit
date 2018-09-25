//
//  Activity.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Model Representation of an activity.
 */
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
    public let map: Map
    public let trainer: Bool
    public let commute: Bool
    public let manual: Bool
    public let privateActivity: Bool
    public let flagged: Bool
    public let gearId: Int?
    public let averageSpeed: Float
    public let maxSpeed: Float
    public let deviceWatts: Bool
    public let hasHeartrate: Bool
    public let elevationHigh: Float
    public let elevationLow: Float
    public let totalPhotoCount: Int
    public let hasKudoed: Bool

    internal let startDateString: String
    internal let startDateLocalString: String

    public let averageWatts: Float?
    public let weightedAverageWatts: Float?
    public let kilojoules: Float?
    public let workoutType: Int?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let activityId: Int = s.value("id"),
            let externalId: String = s.value("external_id"),
            let uploadId: Int = s.value("upload_id"),
            let athleteDictionary: JSONDictionary = s.value("athlete"),
            let a = JSONSupport(dictionary: athleteDictionary),
            let athleteId: Int = a.value("id"),
            let athleteResourceState: Int = a.value("resource_state"),
            let name: String = s.value("name"),
            let distance: Float = s.value("distance"),
            let movingTime: Int = s.value("moving_time"),
            let elapsedTime: Int = s.value("elapsed_time"),
            let totalElevationGain: Float = s.value("total_elevation_gain"),
            let type: String = s.value("type"),
            let startDate: String = s.value("start_date"),
            let startDateLocal: String = s.value("start_date_local"),
            let timezone: String = s.value("timezone"),
            let startCoordinates: [CLLocationDegrees] = s.value("start_latlng"),
            startCoordinates.count == 2,
            let endCoordinates: [CLLocationDegrees] = s.value("end_latlng"),
            endCoordinates.count == 2,
            let city: String = s.value("location_city"),
            let state: String = s.value("location_state"),
            let country: String = s.value("location_country"),
            let achievementCount: Int = s.value("achievement_count"),
            let kudosCount: Int = s.value("kudos_count"),
            let commentCount: Int = s.value("comment_count"),
            let athleteCount: Int = s.value("athlete_count"),
            let photoCount: Int = s.value("photo_count"),
            let mapDictionary: JSONDictionary = s.value("map"),
            let map = Map(dictionary: mapDictionary),
            let trainer: Bool = s.value("trainer"),
            let commute: Bool = s.value("commute"),
            let manual: Bool = s.value("manual"),
            let privateActivity: Bool = s.value("private"),
            let flagged: Bool = s.value("flagged"),
            let averageSpeed: Float = s.value("average_speed"),
            let maxSpeed: Float = s.value("max_speed"),
            let deviceWatts: Bool = s.value("device_watts"),
            let hasHeartrate: Bool = s.value("has_heartrate"),
            let elevationHigh: Float = s.value("elev_high"),
            let elevationLow: Float = s.value("elev_low"),
            let totalPhotoCount: Int = s.value("total_photo_count"),
            let hasKudoed: Bool = s.value("has_kudoed") {
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
            self.startDateString = startDate
            self.startDateLocalString = startDateLocal
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
            self.map = map
            self.trainer = trainer
            self.commute = commute
            self.manual = manual
            self.privateActivity = privateActivity
            self.flagged = flagged
            self.averageSpeed = averageSpeed
            self.maxSpeed = maxSpeed
            self.deviceWatts = deviceWatts
            self.hasHeartrate = hasHeartrate
            self.elevationHigh = elevationHigh
            self.elevationLow = elevationLow
            self.totalPhotoCount = totalPhotoCount
            self.hasKudoed = hasKudoed

            // Optional Properties

            self.gearId = s.value("gear_id", required: false)
            self.averageWatts = s.value("average_watts", required: false)
            self.weightedAverageWatts = s.value("weighted_average_watts", required: false)
            self.kilojoules = s.value("kilojoules", required: false)
            self.workoutType = s.value("workout_type", required: false)
        }
        else {
            return nil
        }
    }

    public static func activities(_ dictionaries: [JSONDictionary]) -> [Activity]? {
        let activities = dictionaries.compactMap { (d) in
            return Activity(dictionary: d)
        }

        return activities.count > 0 ? activities : nil
    }

    public var startCoordinate: CLLocationCoordinate2D {
        guard let latitude = startCoordinates.first,
            let longitude = startCoordinates.last
            else {
                return kCLLocationCoordinate2DInvalid
        }
        return CLLocationCoordinate2DMake(latitude, longitude)
    }

    public var endCoordinate: CLLocationCoordinate2D {
        guard let latitude = endCoordinates.first,
            let longitude = endCoordinates.last
            else {
                return kCLLocationCoordinate2DInvalid
        }
        return CLLocationCoordinate2DMake(latitude, longitude)
    }

    public var startDate: Date? {
        return Strava.dateFromString(startDateString)
    }

    public var startDateLocal: Date? {
        return Strava.dateFromString(startDateLocalString)
    }

}
