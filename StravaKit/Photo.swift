//
//  Photo.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

public struct Photo {
    let source: Int
    let urls: [String : String]

    let photoId: Int?
    let uniqueId: String?
    let activityId: Int?
    let resourceState: Int?
    let ref: String?
    let uid: String?
    let caption: String?
    let type: String?
    let uploadedAt: String?
    let createdAt: String?
    let location: [Double]?

    init?(dictionary: JSONDictionary) {
        if let source = dictionary["source"] as? Int,
            let urls = dictionary["urls"] as? [String : String] {

            self.source = source
            self.urls = urls

            self.photoId = dictionary["id"] as? Int
            self.uniqueId = dictionary["unique_id"] as? String
            self.activityId = dictionary["activity_id"] as? Int
            self.resourceState = dictionary["resource_state"] as? Int
            self.ref = dictionary["ref"] as? String
            self.uid = dictionary["uid"] as? String
            self.caption = dictionary["caption"] as? String
            self.type = dictionary["type"] as? String
            self.uploadedAt = dictionary["uploaded_at"] as? String
            self.createdAt = dictionary["created_at"] as? String
            if let location = dictionary["location"] as? [Double] where location.count == 2 {
                self.location = location
            }
            else {
                self.location = nil
            }

        }
        else {
            return nil
        }
    }

    public var photoURLs: [PhotoURL]? {
        get {
            return PhotoURL.photoURLs(urls)
        }
    }

    public var coordinate: CLLocationCoordinate2D {
        get {
            if let location = location where location.count == 2,
                let latitude = location.first,
                let longitude = location.last {
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                return coordinate
            }
            return kCLLocationCoordinate2DInvalid
        }
    }
}

public struct PhotoURL {
    let size: String
    let URL: NSURL

    internal static func photoURLs(dictionary: [String : String]) -> [PhotoURL]? {
        var photoURLs: [PhotoURL] = []
        for size in dictionary.keys {
            if let urlString = dictionary[size],
                let URL = NSURL(string: urlString) {
                let photoURL = PhotoURL(size: size, URL: URL)
                photoURLs.append(photoURL)
            }
        }

        if photoURLs.count > 0 {
            return photoURLs
        }
        return nil
    }

}
