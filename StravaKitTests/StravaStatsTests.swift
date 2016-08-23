//
//  StravaStatsTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaStatsTests: XCTestCase {
    
    func testStatsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = statsDictionary("stats-good") else {
            XCTFail()
            return
        }

        let stats = Stats(athleteId: 1, dictionary: dictionary)
        XCTAssertNotNil(stats)
    }

    func testStatsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = statsDictionary("stats-bad") else {
            XCTFail()
            return
        }

        let stats = Stats(athleteId: 1, dictionary: dictionary)
        XCTAssertNil(stats)
    }

    func testStatsDetailCreationFromEmptyDictionary() {
        // use empty JSON file for stats dictionary to fail the initializer
        guard let dictionary = statsDictionary("empty") else {
            XCTFail()
            return
        }

        let statsDetail = StatsDetail(dictionary: dictionary)
        XCTAssertNil(statsDetail)
    }

    func testGetStatsGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("stats-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getStats(1) { (stats, error) in
            XCTAssertNotNil(stats)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStatsBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("stats-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getStats(1) { (stats, error) in
            XCTAssertNil(stats)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStatsWithError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getStats(1) { (stats, error) in
            XCTAssertNil(stats)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    // MARK: - Private Functions -

    private func statsDictionary(name: String) -> JSONDictionary? {
        if let json = JSONLoader.sharedInstance.loadJSON(name) as? JSONDictionary {
            return json
        }
        else {
            return nil
        }
    }

}
