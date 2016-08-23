//
//  KeychainTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class KeychainTests: XCTestCase {

    func testDeleteAccessData() {
        let success = Strava.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)
    }

    func testStoreAccessData() {
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        var success = Strava.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)

        let accessToken = "abcxyz"
        let athlete = Athlete(dictionary: dictionary)
        Strava.sharedInstance.accessToken = accessToken
        Strava.sharedInstance.athlete = athlete
        XCTAssertNotNil(Strava.sharedInstance.accessToken)
        XCTAssertNotNil(Strava.sharedInstance.athlete)

        success = Strava.sharedInstance.storeAccessData()

        XCTAssertTrue(success)
    }

    func testLoadAccessData() {
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("athlete-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        var success = Strava.sharedInstance.deleteAccessData()
        XCTAssertTrue(success)

        let accessToken = "abcxyz"
        let athlete = Athlete(dictionary: dictionary)
        Strava.sharedInstance.accessToken = accessToken
        Strava.sharedInstance.athlete = athlete
        XCTAssertNotNil(Strava.sharedInstance.accessToken)
        XCTAssertNotNil(Strava.sharedInstance.athlete)

        success = Strava.sharedInstance.storeAccessData()
        XCTAssertTrue(success)

        Strava.sharedInstance.accessToken = nil
        Strava.sharedInstance.athlete = nil

        success = Strava.sharedInstance.loadAccessData()
        XCTAssertTrue(success)
        XCTAssertTrue(Strava.sharedInstance.accessToken == accessToken)
        XCTAssertTrue(Strava.sharedInstance.athlete?.fullName == athlete?.fullName)
    }

}
