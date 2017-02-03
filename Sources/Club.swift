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
    let clubId: Int
    let resourceState: Int
    let name: String
    let profileMediumURL: URL
    let profileURL: URL
    let sportType: String
    let city: String
    let state: String
    let country: String
    let isPrivate: Bool
    let memberCount: Int
    let featured: Bool
    let verified: Bool
    let url: String

    let coverPhotoURL: URL?
    let coverPhotoSmallURL: URL?
    let clubDescription: String?
    let clubType: String?
    let membership: String?
    let followingCount: Int?
    let admin: Bool?
    let owner: Bool?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
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
            let url: String = s.value("url") {
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
        else {
            return nil
        }
    }

    public static func clubs(_ dictionaries: JSONArray) -> [Club] {
        return dictionaries.flatMap { (d) in
            return Club(dictionary: d)
        }
    }

}
