//
//  Photo.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Model Representation of a photo.
 */
public struct Photo {
    public let source: Int
    public let urls: [String : String]

    public let photoId: Int?
    public let uniqueId: String?
    public let activityId: Int?
    public let resourceState: Int?
    public let ref: String?
    public let uid: String?
    public let caption: String?
    public let type: String?
    public let location: [Double]?

    internal let uploadedAtString: String?
    internal let createdAtString: String?

    public var uploadedAt: Date? {
        return Strava.dateFromString(uploadedAtString)
    }

    public var createdAt: Date? {
        return Strava.dateFromString(createdAtString)
    }

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let source: Int = s.value("source"),
            let urls: [String : String] = s.value("urls") else {
                return nil
        }

        self.source = source
        self.urls = urls

        self.photoId = s.value("id", required: false)
        self.uniqueId = s.value("unique_id", required: false)
        self.activityId = s.value("activity_id", required: false)
        self.resourceState = s.value("resource_state", required: false)
        self.ref = s.value("ref", required: false)
        self.uid = s.value("uid", required: false)
        self.caption = s.value("caption", required: false)
        self.type = s.value("type", required: false)
        self.uploadedAtString = s.value("uploaded_at", required: false)
        self.createdAtString = s.value("created_at", required: false)
        if let location: [Double] = s.value("location"), location.count == 2 {
            self.location = location
        }
        else {
            self.location = nil
        }
    }

    public var photoURLs: [PhotoURL]? {
        return PhotoURL.photoURLs(urls)
    }

    public var coordinate: CLLocationCoordinate2D {
        if let location = location,
            location.count == 2,
            let latitude = location.first,
            let longitude = location.last {
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            return coordinate
        }
        return kCLLocationCoordinate2DInvalid
    }
}

public struct PhotoURL {
    let size: String
    let photoURL: URL

    internal static func photoURLs(_ dictionary: [String : String]) -> [PhotoURL]? {
        let photoURLs: [PhotoURL] = dictionary.compactMap { (pair) in
            let size = pair.0
            guard let urlString = dictionary[size],
                let photoURL = URL(string: urlString)
                else {
                    return nil
            }

            return PhotoURL(size: size, photoURL: photoURL)
        }

        return photoURLs.count > 0 ? photoURLs : nil
    }

}
