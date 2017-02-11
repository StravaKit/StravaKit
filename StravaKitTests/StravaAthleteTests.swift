//
//  StravaAthleteTests.swift
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
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNotNil(athlete)
    }

    func testAthleteCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNil(athlete)
    }

    func testAthleteDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-good") as? JSONDictionary else {
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
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-other") as? JSONDictionary else {
            XCTFail()
            return
        }

        let athlete = Athlete(dictionary: dictionary)
        XCTAssertNotNil(athlete)
    }

    func testAthleteFriendsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("athlete-friends-good") as? JSONArray else {
            XCTFail()
            return
        }

        let athletes = Athlete.athletes(dictionaries)
        XCTAssertNotNil(athletes)
        XCTAssertTrue(athletes.count == 3)
    }

    func testAthleteFriendsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("athlete-friends-bad") as? JSONArray else {
            XCTFail()
            return
        }

        let athletes = Athlete.athletes(dictionaries)
        XCTAssertNotNil(athletes)
        XCTAssertTrue(athletes.count == 0)
    }

    func testAthleteZonesCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-zones-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let zones = Zones(dictionary: dictionary)
        XCTAssertNotNil(zones)
        XCTAssertTrue((zones?.power?.zones.count ?? 0) > 0)
    }

    func testAthleteZonesCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-zones-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let zones = Zones(dictionary: dictionary)
        XCTAssertNil(zones)
    }

    func testGetAthleteGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNotNil(athlete)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteBad() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete() { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            XCTAssertNotNil(athlete)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDBad() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByIDWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthlete(1) { (athlete, error) in
            XCTAssertNil(athlete)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteFriendsGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-friends-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getAthleteFriends(page) { (athletes, error) in
            XCTAssertNotNil(athletes)
            XCTAssertNil(error)
            XCTAssertTrue(athletes?.count == 3)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteFriendsBad() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-friends-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthleteFriends() { (athletes, error) in
            XCTAssertNotNil(athletes)
            XCTAssertNil(error)
            XCTAssertTrue(athletes?.count == 0)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteFriendsInvalid() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getAthleteFriends(page) { (athletes, error) in
            XCTAssertNil(athletes)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteFriendsWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthleteFriends() { (athletes, error) in
            XCTAssertNil(athletes)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteZonesGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-zones-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getAthleteZones(page) { (zones, error) in
            XCTAssertNotNil(zones)
            XCTAssertNil(error)
            XCTAssertTrue(zones?.heartRate?.zones.count == 5)
            XCTAssertTrue(zones?.power?.zones.count == 7)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteZonesBad() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("athlete-zones-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthleteZones() { (zones, error) in
            XCTAssertNil(zones)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteZonesInvalid() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getAthleteZones(page) { (zones, error) in
            XCTAssertNil(zones)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteZonesWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getAthleteZones() { (zones, error) in
            XCTAssertNil(zones)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

}
