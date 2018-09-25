//
//  Club.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/29/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a club.
 */
public struct Club {
    public let clubId: Int
    public let resourceState: Int
    public let name: String
    public let profileMediumURL: URL
    public let profileURL: URL
    public let sportType: String
    public let city: String
    public let state: String
    public let country: String
    public let isPrivate: Bool
    public let memberCount: Int
    public let featured: Bool
    public let verified: Bool
    public let url: String

    public let coverPhotoURL: URL?
    public let coverPhotoSmallURL: URL?
    public let clubDescription: String?
    public let clubType: String?
    public let membership: String?
    public let followingCount: Int?
    public let admin: Bool?
    public let owner: Bool?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let clubId: Int = s.value("id"),
            let resourceState: Int = s.value("resource_state"),
            let name: String = s.value("name"),
            let profileMedium: String = s.value("profile_medium"),
            let profileMediumURL = URL(string: profileMedium),
            let profile: String = s.value("profile"),
            let profileURL = URL(string: profile),
            let sportType: String = s.value("sport_type"),
            let city: String = s.value("city"),
            let state: String = s.value("state"),
            let country: String = s.value("country"),
            let isPrivate: Bool = s.value("private"),
            let memberCount: Int = s.value("member_count"),
            let featured: Bool = s.value("featured"),
            let verified: Bool = s.value("verified"),
            let url: String = s.value("url") else {
                return nil
        }
        self.clubId = clubId
        self.resourceState = resourceState
        self.name = name
        self.profileMediumURL = profileMediumURL
        self.profileURL = profileURL
        self.sportType = sportType
        self.city = city
        self.state = state
        self.country = country
        self.isPrivate = isPrivate
        self.memberCount = memberCount
        self.featured = featured
        self.verified = verified
        self.url = url

        // Optional Properties

        if let coverPhoto: String = s.value("cover_photo", required: false) {
            self.coverPhotoURL = URL(string: coverPhoto)
        }
        else {
            self.coverPhotoURL = nil
        }

        if let coverPhotoSmall: String = s.value("cover_photo_small", required: false) {
            self.coverPhotoSmallURL = URL(string: coverPhotoSmall)
        }
        else {
            self.coverPhotoSmallURL = nil
        }

        self.clubDescription = s.value("description", required: false)
        self.clubType = s.value("club_type", required: false)
        self.membership = s.value("membership", required: false)
        self.followingCount = s.value("following_count", required: false)
        self.admin = s.value("admin", required: false)
        self.owner = s.value("owner", required: false)
    }

    public static func clubs(_ dictionaries: JSONArray) -> [Club] {
        return dictionaries.compactMap { (d) in
            return Club(dictionary: d)
        }
    }

}
