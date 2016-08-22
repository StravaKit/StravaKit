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
            let premium = dictionary["premium"] as? Bool,
            let followerCount = dictionary["follower_count"] as? Int,
            let friendCount = dictionary["friend_count"] as? Int,
            let mutualFriendCount = dictionary["mutual_friend_count"] as? Int,
            let measurementPreference = dictionary["measurement_preference"] as? String,
            let email = dictionary["email"] as? String {

            let athlete: Athlete = Athlete(athleteId: athleteId, resourceState: resourceState, firstName: firstName, lastName: lastName, city: city, state: state, country: country, profileImageURL: profileImageURL, profileMediumImageURL: profileMediumImageURL, sex: sex, premium: premium, followerCount: followerCount, friendCount: friendCount, mutualFriendCount: mutualFriendCount, measurementPreference: measurementPreference, email: email)
            return athlete
        }

        return nil
    }

}
