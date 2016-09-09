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
        XCTAssertNotNil(activities?.count == dictionaries.count)

        if let activity = activities?.first {
            let startCoordinate = activity.startCoordinate
            let endCoordinate = activity.endCoordinate

            XCTAssertTrue(startCoordinate.latitude == 37.729999999999997)
            XCTAssertTrue(startCoordinate.longitude == -122.41)
            XCTAssertTrue(endCoordinate.latitude == 37.799999999999997)
            XCTAssertTrue(endCoordinate.longitude == -122.44)
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

    func testGetActivitiesGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("activities-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getActivities(page) { (activities, error) in
            XCTAssertNotNil(activities)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivitiesBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("activities-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getActivities() { (activities, error) in
            XCTAssertNotNil(activities)
            XCTAssertTrue(activities?.count == 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivitiesError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getActivities() { (activities, error) in
            XCTAssertNil(activities)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivityGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("activity-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getActivity(1) { (activity, error) in
            XCTAssertNotNil(activity)
            XCTAssertNotNil(activity?.startDate)
            XCTAssertNotNil(activity?.startDateLocal)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivityBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("activity-bad")
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getActivity(1) { (activity, error) in
            XCTAssertNil(activity)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivityInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getActivity(1) { (activity, error) in
            XCTAssertNil(activity)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetFollowingActivitiesGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("activities-following")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getFollowingActivities(page) { (activities, error) in
            XCTAssertNotNil(activities)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetFollowingActivitiesBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("empty")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getFollowingActivities() { (activities, error) in
            XCTAssertNotNil(activities)
            XCTAssertTrue(activities?.count == 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetFollowingActivitiesError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getFollowingActivities() { (activities, error) in
            XCTAssertNil(activities)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
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
