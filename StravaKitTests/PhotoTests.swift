//
//  PhotoTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
import CoreLocation

@testable import StravaKit

class PhotoTests: XCTestCase {

    func testPhotoEmpty() {
        guard let json = JSONLoader.sharedInstance.loadJSON("empty") as? JSONDictionary else {
            XCTFail()
            return
        }

        let photo = Photo(dictionary: json)
        XCTAssertNil(photo)
    }

    func testPhotoLight() {
        guard let json = JSONLoader.sharedInstance.loadJSON("photo-light") as? JSONDictionary else {
            XCTFail()
            return
        }

        let photo = Photo(dictionary: json)
        XCTAssertNotNil(photo)
        if let photo = photo,
            let photoURLs = photo.photoURLs {
            XCTAssertTrue(photoURLs.count == 2)
        }
        else {
            XCTFail()
        }
    }

    func testPhotoHeavy() {
        guard let json = JSONLoader.sharedInstance.loadJSON("photo-heavy") as? JSONDictionary else {
            XCTFail()
            return
        }

        let epsilon = Double(Float.ulpOfOne)
        let latitude = Double(37.839333333)
        let longitude = Double(-122.489833333)

        let photo = Photo(dictionary: json)
        XCTAssertNotNil(photo)
        if let photo = photo,
            let photoURLs = photo.photoURLs {
            XCTAssertTrue(photoURLs.count == 1)

            XCTAssertNotNil(photo.createdAt)
            XCTAssertNotNil(photo.uploadedAt)

            let coordinate = photo.coordinate
            XCTAssertTrue(CLLocationCoordinate2DIsValid(coordinate))
            XCTAssertEqual(latitude, coordinate.latitude, accuracy: epsilon)
            XCTAssertEqual(longitude, coordinate.longitude, accuracy: epsilon)
        }
        else {
            XCTFail()
        }
    }

    func testPhotoNoLocation() {
        guard let json = JSONLoader.sharedInstance.loadJSON("photo-heavy") as? JSONDictionary else {
            XCTFail()
            return
        }

        var dictionary = json
        dictionary.removeValue(forKey: "location")
        let photo = Photo(dictionary: dictionary)
        XCTAssertNotNil(photo)

        if let photo = photo {
            let coordinate = photo.coordinate
            XCTAssertFalse(CLLocationCoordinate2DIsValid(coordinate))
        }
        else {
            XCTFail()
        }
    }

    func testPhotoNoURLs() {
        guard let json = JSONLoader.sharedInstance.loadJSON("photo-heavy") as? JSONDictionary else {
            XCTFail()
            return
        }

        var dictionary = json
        let emptyURLs: [String : String] = [:]
        dictionary["urls"] = emptyURLs
        let photo = Photo(dictionary: dictionary)
        XCTAssertNotNil(photo)

        if let photo = photo {
            XCTAssertNil(photo.photoURLs)
        }
        else {
            XCTFail()
        }
    }

}
