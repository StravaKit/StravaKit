//
//  Club.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/29/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct Club {
    let clubId: Int
    let resourceState: Int
    let name: String
    let profileMediumURL: NSURL
    let profileURL: NSURL
    let coverPhotoURL: NSURL
    let coverPhotoSmallURL: NSURL
    let clubDescription: String?
    let clubType: String
    let sportType: String
    let city: String
    let state: String
    let country: String
    let isPrivate: Bool
    let memberCount: Int
    let featured: Bool
    let verified: Bool
    let membership: String?
    let admin: Bool?
    let owner: Bool?
    let followingCount: Int?
    let url: String

    init?(dictionary: JSONDictionary) {
        if let clubId = dictionary["id"] as? Int,
            let resourceState = dictionary["resource_state"] as? Int,
            let name = dictionary["name"] as? String,
            let profileMedium = dictionary["profile_medium"] as? String,
            let profileMediumURL = NSURL(string: profileMedium),
            let profile = dictionary["profile"] as? String,
            let profileURL = NSURL(string: profile),
            let coverPhoto = dictionary["cover_photo"] as? String,
            let coverPhotoURL = NSURL(string: coverPhoto),
            let coverPhotoSmall = dictionary["cover_photo_small"] as? String,
            let coverPhotoSmallURL = NSURL(string: coverPhotoSmall),
            let clubType = dictionary["club_type"] as? String,
            let sportType = dictionary["sport_type"] as? String,
            let city = dictionary["city"] as? String,
            let state = dictionary["state"] as? String,
            let country = dictionary["country"] as? String,
            let isPrivate = dictionary["private"] as? Bool,
            let memberCount = dictionary["member_count"] as? Int,
            let featured = dictionary["featured"] as? Bool,
            let verified = dictionary["verified"] as? Bool,
            let url = dictionary["url"] as? String {
            self.clubId = clubId
            self.resourceState = resourceState
            self.name = name
            self.profileMediumURL = profileMediumURL
            self.profileURL = profileURL
            self.coverPhotoURL = coverPhotoURL
            self.coverPhotoSmallURL = coverPhotoSmallURL
            self.clubType = clubType
            self.sportType = sportType
            self.city = city
            self.state = state
            self.country = country
            self.isPrivate = isPrivate
            self.memberCount = memberCount
            self.featured = featured
            self.verified = verified
            self.url = url

            // Optional properties
            self.clubDescription = dictionary["description"] as? String
            self.membership = dictionary["membership"] as? String
            self.admin = dictionary["admin"] as? Bool
            self.owner = dictionary["owner"] as? Bool
            self.followingCount = dictionary["following_count"] as? Int
        }
        else {
            return nil
        }
    }

}