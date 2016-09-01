//
//  Athlete.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
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

    public var dictionary: JSONDictionary {
        get {
            let dictionary: JSONDictionary = [
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

    init?(dictionary: JSONDictionary) {
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

            self.athleteId = athleteId
            self.resourceState = resourceState
            self.firstName = firstName
            self.lastName = lastName
            self.city = city
            self.state = state
            self.country = country
            self.profileImageURL = profileImageURL
            self.profileMediumImageURL = profileMediumImageURL
            self.sex = sex
            self.premium = premium

            // Optional properties
            if let followerCount = dictionary["follower_count"] as? Int,
                let friendCount = dictionary["friend_count"] as? Int,
                let mutualFriendCount = dictionary["mutual_friend_count"] as? Int,
                let measurementPreference = dictionary["measurement_preference"] as? String,
                let email = dictionary["email"] as? String {
                self.followerCount = followerCount
                self.friendCount = friendCount
                self.mutualFriendCount = mutualFriendCount
                self.measurementPreference = measurementPreference
                self.email = email
            }
            else {
                // default values for optional properties
                self.followerCount = 0
                self.friendCount = 0
                self.mutualFriendCount = 0
                self.measurementPreference = "meters"
                self.email = ""
            }
        }
        else {
            return nil
        }
    }

}
