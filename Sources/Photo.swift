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

    public var uploadedAt: NSDate? {
        get {
            return Strava.dateFromString(uploadedAtString)
        }
    }

    public var createdAt: NSDate? {
        get {
            return Strava.dateFromString(createdAtString)
        }
    }

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let source: Int = s.value("source"),
            let urls: [String : String] = s.value("urls") {

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
            if let location: [Double] = s.value("location") where location.count == 2 {
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
        let photoURLs: [PhotoURL] = dictionary.flatMap { (pair) in
            let size = pair.0
            guard let urlString = dictionary[size],
                let URL = NSURL(string: urlString)
                else {
                    return nil
            }

            return PhotoURL(size: size, URL: URL)
        }

        return photoURLs.count > 0 ? photoURLs : nil
    }
    
}
