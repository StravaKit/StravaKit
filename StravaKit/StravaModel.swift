//
//  StravaModel.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/20/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct Athlete {
    public let athleteId: Int
    public let resourceState: Int
    public let firstName: String
    public let lastName: String
    public let city: String
    public let state: String
    public let country: String
    public let profileImageURL : NSURL
    public let profileMediumImageURL : NSURL
    public let sex: String
    public let premium: Bool
    public let followerCount: Int
    public let friendCount: Int
    public let mutualFriendCount: Int
    public let measurementPreference: String
    internal let email: String

    public var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }

    public var dictionary: [String : AnyObject] {
        get {
            let dictionary: [String : AnyObject] = [
                "id" : athleteId,
                "resource_state" : resourceState,
                "firstname" : firstName,
                "lastname" : lastName,
                "city" : city,
                "state" : state,
                "country" : country,
                "profile" : String(profileImageURL),
                "profile_medium" : String(profileMediumImageURL),
                "sex" : sex,
                "premium" : premium,
                "follower_count" : followerCount,
                "friend_count" : friendCount,
                "mutual_friend_count" : mutualFriendCount,
                "measurement_preference" : measurementPreference,
                "email" : email
            ]

            return dictionary
        }
    }

    public static func athlete(dictionary: [String : AnyObject]) -> Athlete? {
        if let athleteId = dictionary["id"] as? Int,
            let resourceState = dictionary["resource_state"] as? Int,
            let firstName = dictionary["firstname"] as? String,
            let lastName = dictionary["lastname"] as? String,
            let city = dictionary["city"] as? String,
            let state = dictionary["state"] as? String,
            let country = dictionary["country"] as? String,
            let profile = dictionary["profile"] as? String,
            let profileImageURL = NSURL(string: profile),
            let profileMedium = dictionary["profile_medium"] as? String,
            let profileMediumImageURL = NSURL(string: profileMedium),
            let sex = dictionary["sex"] as? String,
            let premium = dictionary["premium"] as? Bool {

            if let followerCount = dictionary["follower_count"] as? Int,
                let friendCount = dictionary["friend_count"] as? Int,
                let mutualFriendCount = dictionary["mutual_friend_count"] as? Int,
                let measurementPreference = dictionary["measurement_preference"] as? String,
                let email = dictionary["email"] as? String {
                let athlete: Athlete = Athlete(athleteId: athleteId, resourceState: resourceState, firstName: firstName, lastName: lastName, city: city, state: state, country: country, profileImageURL: profileImageURL, profileMediumImageURL: profileMediumImageURL, sex: sex, premium: premium, followerCount: followerCount, friendCount: friendCount, mutualFriendCount: mutualFriendCount, measurementPreference: measurementPreference, email: email)
                return athlete
            }
            else {
                let athlete: Athlete = Athlete(athleteId: athleteId, resourceState: resourceState, firstName: firstName, lastName: lastName, city: city, state: state, country: country, profileImageURL: profileImageURL, profileMediumImageURL: profileMediumImageURL, sex: sex, premium: premium, followerCount: 0, friendCount: 0, mutualFriendCount: 0, measurementPreference: "", email: "")
                return athlete

            }
        }
        
        return nil
    }
    
}

public struct Stats {
    public let athleteId: Int
    public let biggestRideDistance: Float
    public let biggestClimbElevationGain: Float

    public let recentRideTotals: StatsDetail?
    public let recentRunTotals: StatsDetail
    public let recentSwimTotals: StatsDetail

    public let ytdRideTotals: StatsDetail
    public let ytdRunTotals: StatsDetail
    public let ytdSwimTotals: StatsDetail

    public let allRideTotals: StatsDetail
    public let allRunTotals: StatsDetail
    public let allSwimTotals: StatsDetail

    public static func stats(athleteId: Int, dictionary: [String : AnyObject]) -> Stats? {

        if let biggestRideDistance = dictionary["biggest_ride_distance"] as? Float,
            let biggestClimbElevationGain = dictionary["biggest_climb_elevation_gain"] as? Float,

            let recentRideTotalsDictionary = dictionary["recent_ride_totals"] as? [String : AnyObject],
            let recentRideTotals = StatsDetail.statsDetail(recentRideTotalsDictionary),
            let recentRunTotalsDictionary = dictionary["recent_run_totals"] as? [String : AnyObject],
            let recentRunTotals = StatsDetail.statsDetail(recentRunTotalsDictionary),
            let recentSwimTotalsDictionary = dictionary["recent_swim_totals"] as? [String : AnyObject],
            let recentSwimTotals = StatsDetail.statsDetail(recentSwimTotalsDictionary),

            let ytdRideTotalsDictionary = dictionary["ytd_ride_totals"] as? [String : AnyObject],
            let ytdRideTotals = StatsDetail.statsDetail(ytdRideTotalsDictionary),
            let ytdRunTotalsDictionary = dictionary["ytd_run_totals"] as? [String : AnyObject],
            let ytdRunTotals = StatsDetail.statsDetail(ytdRunTotalsDictionary),
            let ytdSwimTotalsDictionary = dictionary["ytd_swim_totals"] as? [String : AnyObject],
            let ytdSwimTotals = StatsDetail.statsDetail(ytdSwimTotalsDictionary),

            let allRideTotalsDictionary = dictionary["all_ride_totals"] as? [String : AnyObject],
            let allRideTotals = StatsDetail.statsDetail(allRideTotalsDictionary),
            let allRunTotalsDictionary = dictionary["all_run_totals"] as? [String : AnyObject],
            let allRunTotals = StatsDetail.statsDetail(allRunTotalsDictionary),
            let allSwimTotalsDictionary = dictionary["all_swim_totals"] as? [String : AnyObject],
            let allSwimTotals = StatsDetail.statsDetail(allSwimTotalsDictionary) {

            let stats = Stats(athleteId: athleteId, biggestRideDistance: biggestRideDistance, biggestClimbElevationGain: biggestClimbElevationGain, recentRideTotals: recentRideTotals, recentRunTotals: recentRunTotals, recentSwimTotals: recentSwimTotals, ytdRideTotals: ytdRideTotals, ytdRunTotals: ytdRunTotals, ytdSwimTotals: ytdSwimTotals, allRideTotals: allRideTotals, allRunTotals: allRunTotals, allSwimTotals: allSwimTotals)

            return stats
        }

        return nil
    }

}

public struct StatsDetail {
    public let count: Int
    public let distance: Float
    public let movingTime: Int
    public let elapsedTime: Int
    public let elevationGain: Float
    public let achievementCount: Int?

    public static func statsDetail(dictionary: [String : AnyObject]) -> StatsDetail? {
        if let count = dictionary["count"] as? Int,
            let distance = dictionary["distance"] as? Float,
            let movingTime = dictionary["moving_time"] as? Int,
            let elapsedTime = dictionary["elapsed_time"] as? Int,
            let elevationGain = dictionary["elevation_gain"] as? Float {
            let achievementCount = dictionary["achievement_count"] as? Int

            let statsDetail = StatsDetail(count: count, distance: distance, movingTime: movingTime, elapsedTime: elapsedTime, elevationGain: elevationGain, achievementCount: achievementCount)

            return statsDetail
        }

        return nil
    }

}
