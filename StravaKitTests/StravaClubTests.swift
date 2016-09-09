//
//  ClubTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/29/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaClubTests: XCTestCase {

    func testClubCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("club-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let club = Club(dictionary: dictionary)
        XCTAssertNotNil(club)
    }

    func testClubCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("club-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let club = Club(dictionary: dictionary)
        XCTAssertNil(club)
    }

    func testClubsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("clubs-good") as? JSONArray else {
            XCTFail()
            return
        }

        let clubs = Club.clubs(dictionaries)
        XCTAssertNotNil(clubs)
        XCTAssertTrue(clubs.count == 2)
    }

    func testClubsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("clubs-bad") as? JSONArray else {
            XCTFail()
            return
        }

        let clubs = Club.clubs(dictionaries)
        XCTAssertNotNil(clubs)
        XCTAssertTrue(clubs.count == 0)
    }
    
    func testGetClubGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("club-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getClub(1) { (club, error) in
            XCTAssertNotNil(club)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("club-bad")
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getClub(1) { (club, error) in
            XCTAssertNil(club)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getClub(1) { (club, error) in
            XCTAssertNil(club)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubsGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("clubs-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getClubs(page) { (clubs, error) in
            XCTAssertNotNil(clubs)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubsBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("clubs-bad")
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getClubs { (clubs, error) in
            XCTAssertNil(clubs)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubsInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getClubs { (clubs, error) in
            XCTAssertNil(clubs)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 15
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

}
