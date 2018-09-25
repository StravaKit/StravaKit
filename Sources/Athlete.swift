//
//  Athlete.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of an athlete.
 */
public struct Athlete {
    public let athleteId: Int
    public let resourceState: Int
    public let firstName: String
    public let lastName: String
    public let city: String
    public let state: String
    public let country: String
    public let profileImageURL: URL
    public let profileMediumImageURL: URL
    public let sex: String
    public let premium: Bool

    public let followerCount: Int?
    public let friendCount: Int?
    public let mutualFriendCount: Int?
    public let measurementPreference: String?
    public let email: String?

    public var fullName: String {
        return "\(firstName) \(lastName)"
    }

    public var dictionary: JSONDictionary {
        var dictionary: JSONDictionary = [
            "id" : athleteId,
            "resource_state" : resourceState,
            "firstname" : firstName,
            "lastname" : lastName,
            "city" : city,
            "state" : state,
            "country" : country,
            "profile" : profileImageURL.absoluteString,
            "profile_medium" : profileMediumImageURL.absoluteString,
            "sex" : sex,
            "premium" : premium
        ]

        if let followerCount = followerCount {
            dictionary["follower_count"] = followerCount
        }
        if let friendCount = friendCount {
            dictionary["friend_count"] = friendCount
        }
        if let mutualFriendCount = mutualFriendCount {
            dictionary["mutual_friend_count"] = mutualFriendCount
        }
        if let measurementPreference = measurementPreference {
            dictionary["measurement_preference"] = measurementPreference
        }
        if let email = email {
            dictionary["email"] = email
        }

        return dictionary
    }

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let athleteId: Int = s.value("id"),
            let resourceState: Int = s.value("resource_state"),
            let firstName: String = s.value("firstname"),
            let lastName: String = s.value("lastname"),
            let city: String = s.value("city"),
            let state: String = s.value("state"),
            let country: String = s.value("country"),
            let profile: String = s.value("profile"),
            let profileImageURL = URL(string: profile),
            let profileMedium: String = s.value("profile_medium"),
            let profileMediumImageURL = URL(string: profileMedium),
            let sex: String = s.value("sex"),
            let premium: Bool = s.value("premium")
            else {
                return nil
        }
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

        // Optional Properties

        self.followerCount = s.value("follower_count", required: false, nilValue: 0)
        self.friendCount = s.value("friend_count", required: false, nilValue: 0)
        self.mutualFriendCount = s.value("mutual_friend_count", required: false, nilValue: 0)
        self.measurementPreference = s.value("measurement_preference", required: false, nilValue: "meters")
        self.email = s.value("email", required: false, nilValue: nil)
    }

    /**
     Creates athlete models from an array of dictionaries.
     */
    public static func athletes(_ dictionaries: JSONArray) -> [Athlete] {
        return dictionaries.compactMap { (d) in
            Athlete(dictionary: d)
        }
    }

}
