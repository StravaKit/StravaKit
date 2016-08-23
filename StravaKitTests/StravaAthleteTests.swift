//
//  StravaAtheleteTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/21/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaAthleteTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Place setup code here
    }

    override func tearDown() {
        //Strava.sharedInstance.alternateRequestor = nil
        super.tearDown()
    }

    func testAthleteCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = athleteDictionary("athlete-good") else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNotNil(athlete)
    }

    func testAthleteCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = athleteDictionary("athlete-bad") else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNil(athlete)
    }

    func testAthleteDictionary() {
        // all required values are in the JSON file
        guard let dictionary = athleteDictionary("athlete-good") else {
            XCTFail()
            return
        }

        guard let athlete = Athlete(dictionary: dictionary),
            let otherAthlete = Athlete(dictionary: athlete.dictionary) else {
                XCTFail()
                return
        }
        XCTAssertTrue(athlete.firstName == otherAthlete.firstName)
        XCTAssertTrue(athlete.lastName == otherAthlete.lastName)
        XCTAssertTrue(athlete.city == otherAthlete.city)
        XCTAssertTrue(athlete.state == otherAthlete.state)
        XCTAssertTrue(athlete.country == otherAthlete.country)
        XCTAssertTrue(athlete.email == otherAthlete.email)
    }

    func testAthleteCreationFromOtherDictionary() {
        // other athlete JSON which is not as full
        guard let dictionary = athleteDictionary("athlete-other") else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNotNil(athlete)
    }

    func testGetAthleteGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNotNil(athlete)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteWithError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            XCTAssertNotNil(athlete)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDWithError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            print("testGetAthleteByIDWithError")
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 30
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    // MARK: Private

    private func athleteDictionary(name: String) -> JSONDictionary? {
        if let json = JSONLoader.sharedInstance.loadJSON(name) as? JSONDictionary {
            return json
        }
        else {
            return nil
        }
    }

}
