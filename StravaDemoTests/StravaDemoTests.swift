//
//  StravaDemoTests.swift
//  StravaDemoTests
//
//  Created by Brennan Stehling on 8/18/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
@testable import StravaDemo
@testable import StravaKit

class StravaDemoTests: XCTestCase {

    let ClientId: String = "1234"
    let ClientSecret: String = "abcxyz"
    let RedirectURI: String = "stravademo://localhost/oauth/signin"
    let AccessToken: String = "xyz123abc987"

    func testLoadDefaults() {
        guard let vc = getHomeViewController() else {
            XCTFail()
            return
        }

        // Load current defaults
        vc.loadDefaults()
        let clientId = vc.clientId
        let clientSecret = vc.clientSecret

        // Change default to test values
        vc.clientId = ClientId
        vc.clientSecret = ClientSecret

        vc.storeDefaults()
        UserDefaults.standard.synchronize()
        vc.loadDefaults()
        Strava.set(clientId: vc.clientId, clientSecret: vc.clientSecret, redirectURI: RedirectURI)
        XCTAssertTrue(vc.clientId == Strava.sharedInstance.clientId)
        XCTAssertTrue(vc.clientSecret == Strava.sharedInstance.clientSecret)
        XCTAssertTrue(ClientId == Strava.sharedInstance.clientId)
        XCTAssertTrue(ClientSecret == Strava.sharedInstance.clientSecret)

        // Return existing defaults
        vc.clientId = clientId
        vc.clientSecret = clientSecret
        vc.storeDefaults()
        UserDefaults.standard.synchronize()
    }

    func testGetAthlete() {
        let expectation = self.expectation(description: "UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController() else {
            XCTFail()
            return
        }

        vc.getAthlete { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByID() {
        let expectation = self.expectation(description: "UI")

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        let requestor = JSONRequestor()
        requestor.response = athleteResponse
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
            XCTFail()
            return
        }

        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getAthleteByID { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetStats() {
        let expectation = self.expectation(description: "UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("stats-good")
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
            XCTFail()
            return
        }
        
        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getStats { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetActivities() {
        let expectation = self.expectation(description: "UI")

        guard let activities = JSONLoader.sharedInstance.loadJSON("activities-good"),
            let activity = JSONLoader.sharedInstance.loadJSON("activity-good") else {
                XCTFail()
                return
        }

        let requestor = JSONRequestor()
        requestor.responses = [activities, activity]
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
                XCTFail()
                return
        }

        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getActivities { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetFollowerActivities() {
        let expectation = self.expectation(description: "UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("activities-following")
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
                XCTFail()
                return
        }

        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getFollowingActivities { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetClub() {
        let expectation = self.expectation(description: "UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("club-good")
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController() else {
            XCTFail()
            return
        }

        vc.getClub { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testGetClubs() {
        let expectation = self.expectation(description: "UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("clubs-good")
        requestor.error = nil
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController() else {
            XCTFail()
            return
        }

        vc.getClubs { (success, error) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    // MARK: - Private Functions -

    fileprivate func getHomeViewController() -> HomeViewController? {
        if let nc = getNavigationController(),
            let vc = nc.topViewController as? HomeViewController {
            return vc
        }

        return nil
    }

    fileprivate func getNavigationController() -> UINavigationController? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window,
            let navigationController = window.rootViewController as? UINavigationController {
            return navigationController
        }

        return nil
    }

}
