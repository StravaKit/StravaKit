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

        vc.clientId = ClientId
        vc.clientSecret = ClientSecret

        vc.storeDefaults()
        NSUserDefaults.standardUserDefaults().synchronize()
        vc.loadDefaults()
        Strava.set(clientId: vc.clientId, clientSecret: vc.clientSecret, redirectURI: RedirectURI)
        XCTAssertTrue(vc.clientId == Strava.sharedInstance.clientId)
        XCTAssertTrue(vc.clientSecret == Strava.sharedInstance.clientSecret)
        XCTAssertTrue(ClientId == Strava.sharedInstance.clientId)
        XCTAssertTrue(ClientSecret == Strava.sharedInstance.clientSecret)
    }

    func testGetAthlete() {
        let expectation = self.expectationWithDescription("UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("athlete-good")
        requestor.error = nil
        requestor.callback = {
            expectation.fulfill()
        }
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController() else {
            XCTFail()
            return
        }

        vc.getAthleteTapped(vc.getAthleteButton)

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetAthleteByID() {
        let expectation = self.expectationWithDescription("UI")

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        let requestor = JSONRequestor()
        requestor.response = athleteResponse
        requestor.error = nil
        requestor.callback = {
            expectation.fulfill()
        }
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
            XCTFail()
            return
        }

        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getAthleteByIDButtonTapped(vc.getAthleteByIDButton)

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout, handler: nil)
    }

    func testGetStats() {
        let expectation = self.expectationWithDescription("UI")

        let requestor = JSONRequestor()
        requestor.response = JSONLoader.sharedInstance.loadJSON("stats-good")
        requestor.error = nil
        requestor.callback = {
            expectation.fulfill()
        }
        Strava.sharedInstance.alternateRequestor = requestor
        Strava.sharedInstance.accessToken = AccessToken

        let athleteResponse = JSONLoader.sharedInstance.loadJSON("athlete-good")

        guard let vc = getHomeViewController(),
            let dictionary = athleteResponse as? JSONDictionary else {
            XCTFail()
            return
        }
        
        Strava.sharedInstance.athlete = Athlete(dictionary: dictionary)

        vc.getStatsButtonTapped(vc.getStatsButton)

        let timeout: NSTimeInterval = 3
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    // MARK: - Private Functions -

    private func getHomeViewController() -> HomeViewController? {
        if let nc = getNavigationController(),
            let vc = nc.topViewController as? HomeViewController {
            return vc
        }

        return nil
    }

    private func getNavigationController() -> UINavigationController? {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            let window = appDelegate.window,
            let navigationController = window.rootViewController as? UINavigationController {
            return navigationController
        }

        return nil
    }

}
