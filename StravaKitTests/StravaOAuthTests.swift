//
//  StravaOAuth.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaOAuthTests: XCTestCase {

    let ClientId: String = "1234"
    let ClientSecret: String = "abcxyz"
    let RedirectURI: String = "stravademo://localhost/oauth/signin"

    override func setUp() {
        super.setUp()

        // Clear out access data
        Strava.sharedInstance.deleteAccessData()
        Strava.set(clientId: ClientId, clientSecret: ClientSecret, redirectURI: RedirectURI)
    }

    override func tearDown() {
        Strava.sharedInstance.alternateRequestor = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil)
        super.tearDown()
    }

    func testUserLoginURL() {
        guard let loginURL = Strava.userLogin(scope: .Public),
            let range = loginURL.absoluteString.range(of:StravaBaseURL),
            let clientId = Strava.queryStringValue(loginURL, name: "client_id"),
            let redirectURI = Strava.queryStringValue(loginURL, name: "redirect_uri"),
            let scope = Strava.queryStringValue(loginURL, name: "scope") else {
            XCTFail()
            return
        }

        XCTAssertFalse(range.isEmpty)
        XCTAssertTrue(clientId == Strava.sharedInstance.clientId)
        XCTAssertTrue(redirectURI == Strava.sharedInstance.redirectURI)
        XCTAssertTrue(scope == "public")
    }

    func testUserLoginURLWithoutCredentials() {
        // Clear out the credentials
        Strava.sharedInstance.clientId = nil
        Strava.sharedInstance.clientSecret = nil

        let loginURL = Strava.userLogin(scope: .Public)

        XCTAssertNil(loginURL)
    }

    func testOpenURLWithCode() {
        let expectation = self.expectation(description: "Notification")

        let callbackURL = URL(string: "\(RedirectURI)?state=&code=1234")!
        let sourceApplication = "com.apple.SafariViewService"

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("exchange-token-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let nc = NotificationCenter.default
        var observer: NSObjectProtocol? = nil
        observer = nc.addObserver(forName: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil, queue: nil) { (notification) in
            if let status = notification.userInfo?[StravaStatusKey] as? String {
                XCTAssertTrue(status == StravaStatusSuccessValue)
                XCTAssertNil(notification.userInfo?[StravaErrorKey])
            }

            if let observer = observer {
                nc.removeObserver(observer)
            }

            expectation.fulfill()
        }

        let opened = Strava.openURL(callbackURL, sourceApplication: sourceApplication)
        XCTAssertTrue(opened)

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testOpenURLWithCodeWithoutCredentials() {
        let callbackURL = URL(string: "\(RedirectURI)?state=&code=1234")!
        let sourceApplication = "com.apple.SafariViewService"

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        // Clear out the credentials
        Strava.sharedInstance.clientId = nil
        Strava.sharedInstance.clientSecret = nil

        let opened = Strava.openURL(callbackURL, sourceApplication: sourceApplication)
        XCTAssertFalse(opened)
    }

    func testOpenURLWithError() {
        let callbackURL = URL(string: "\(RedirectURI)?state=&error=access_denied")!
        let sourceApplication = "com.apple.SafariViewService"

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let opened = Strava.openURL(callbackURL, sourceApplication: sourceApplication)
        XCTAssertTrue(opened)
    }

    func testOpenURLWithInvalidSourceApplication() {
        let callbackURL = URL(string: "\(RedirectURI)?state=&error=access_denied")!
        let sourceApplication = "com.acme.App"

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let opened = Strava.openURL(callbackURL, sourceApplication: sourceApplication)
        XCTAssertFalse(opened)
    }

    func testOpenURLWithInvalidRedirectURI() {
        let callbackURL = URL(string: "acme://localhost/oauth?state=&code=1234")!
        let sourceApplication = "com.apple.SafariViewService"

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let opened = Strava.openURL(callbackURL, sourceApplication: sourceApplication)
        XCTAssertFalse(opened)
    }

    func testExchangeTokenGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("exchange-token-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.exchangeTokenWithCode("1234") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertTrue(Strava.isAuthorized)
            XCTAssertNil(error)

            if let currentAthlete = Strava.currentAthlete {
                XCTAssertTrue(currentAthlete.firstName == "John")
                XCTAssertTrue(currentAthlete.lastName == "Applestrava")
            }
            else {
                XCTFail()
            }

            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testExchangeTokenBad() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("exchange-token-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.exchangeTokenWithCode("1234") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testExchangeTokenMissingCredentials() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("exchange-token-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        // Clear out the credentials
        Strava.sharedInstance.clientId = nil
        Strava.sharedInstance.clientSecret = nil

        Strava.exchangeTokenWithCode("1234") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testExchangeTokenWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.exchangeTokenWithCode("1234") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testDeauthorizeGood() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("empty")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.deauthorize() { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testDeauthorizeGoodWithError() {
        let expectation = self.expectation(description: "API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("empty")
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.deauthorize() { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testNotifyAuthorizationCompletedGood() {
        let expectation = self.expectation(description: "Notification")

        let nc = NotificationCenter.default
        var observer: NSObjectProtocol? = nil
        observer = nc.addObserver(forName: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil, queue: nil) { (notification) in
            if let status = notification.userInfo?[StravaStatusKey] as? String {
                XCTAssertTrue(status == StravaStatusSuccessValue)
                XCTAssertNil(notification.userInfo?[StravaErrorKey])
            }

            if let observer = observer {
                nc.removeObserver(observer)
            }

            expectation.fulfill()
        }

        Strava.notifyAuthorizationCompleted(true, error: nil)

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testNotifyAuthorizationCompletedBad() {
        let expectation = self.expectation(description: "Notification")

        let nc = NotificationCenter.default
        var observer: NSObjectProtocol? = nil
        observer = nc.addObserver(forName: NSNotification.Name(rawValue: StravaAuthorizationCompletedNotification), object: nil, queue: nil) { (notification) in
            if let status = notification.userInfo?[StravaStatusKey] as? String {
                XCTAssertTrue(status == StravaStatusFailureValue)
                XCTAssertNotNil(notification.userInfo?[StravaErrorKey])
            }

            if let observer = observer {
                nc.removeObserver(observer)
            }

            expectation.fulfill()
        }

        let error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.notifyAuthorizationCompleted(false, error: error)

        let timeout: TimeInterval = 120
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

}
