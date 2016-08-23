//
//  StravaActivityTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaActivityTests: XCTestCase {

    func testActivitiesCreationFromGoodArray() {
        // all required values are in the JSON file
        guard let dictionaries = activitiesDictionaries("activities-good") else {
            XCTFail()
            return
        }

        let activities = Activity.activities(dictionaries)
        XCTAssertNotNil(activities)

        if let activity = activities?.first {
            let startCoordinate = activity.startCoordinate
            let endCoordinate = activity.endCoordinate

            XCTAssertTrue(startCoordinate.latitude == 37.73697)
            XCTAssertTrue(startCoordinate.longitude == -122.416727)
            XCTAssertTrue(endCoordinate.latitude == 37.786237)
            XCTAssertTrue(endCoordinate.longitude == -122.398677)
        }
    }

    func testActivitiesCreationFromBadArray() {
        // required values are missing from the JSON file
        guard let dictionaries = activitiesDictionaries("activities-bad") else {
            XCTFail()
            return
        }

        let activities = Activity.activities(dictionaries)
        XCTAssertNil(activities)
    }

    func testActivitiesCreationFromEmptyArray() {
        // use an empty array
        let dictionaries: [JSONDictionary] = []
        let activities = Activity.activities(dictionaries)
        XCTAssertNil(activities)
    }


    func testActivityCreationFromEmptyDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("empty") as? JSONDictionary else {
            XCTFail()
            return
        }

        let activity = Activity(dictionary: dictionary)
        XCTAssertNil(activity)
    }

    // MARK: - Private Functions -

    private func activitiesDictionaries(name: String) -> [JSONDictionary]? {
        let bundle = NSBundle(forClass: self.classForCoder)
        guard let path = bundle.pathForResource(name, ofType: "json") else {
            return nil
        }
        let fm = NSFileManager.defaultManager()
        if fm.isReadableFileAtPath(path) {
            guard let data = fm.contentsAtPath(path) else {
                return nil
            }
            do {
                if let dictionaries = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [JSONDictionary] {
                    return dictionaries
                }
            }
            catch {
                // do nothing
            }
        }

        return nil
    }


}
