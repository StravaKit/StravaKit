//
//  StravaRouteTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/9/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaRouteTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testRouteCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("route-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let route = Route(dictionary: dictionary)
        XCTAssertNotNil(route)
    }

    func testRouteCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("route-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let route = Route(dictionary: dictionary)
        XCTAssertNil(route)
    }

    func testRoutesCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("routes-good") as? JSONArray else {
            XCTFail()
            return
        }

        let routes = Route.routes(dictionaries)
        XCTAssertNotNil(routes)
        XCTAssertTrue(routes.count == 6)
    }

    func testRoutesCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("routes-bad") as? JSONArray else {
            XCTFail()
            return
        }

        let routes = Route.routes(dictionaries)
        XCTAssertNotNil(routes)
        XCTAssertTrue(routes.count == 0)
    }

    func testGetRouteGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("route-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoute(1) { (route, error) in
            XCTAssertNotNil(route)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRouteBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("route-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoute(1) { (route, error) in
            XCTAssertNil(route)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRouteInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoute(1) { (route, error) in
            XCTAssertNil(route)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRouteWithError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoute(1) { (routes, error) in
            XCTAssertNil(routes)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRoutesGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("routes-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getRoutes(1, page: page) { (routes, error) in
            XCTAssertNotNil(routes)
            XCTAssertNil(error)
            XCTAssertTrue(routes?.count == 6)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRoutesBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("routes-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoutes(1) { (routes, error) in
            XCTAssertNotNil(routes)
            XCTAssertNil(error)
            XCTAssertTrue(routes?.count == 0)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRoutesInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getRoutes(1, page: page) { (routes, error) in
            XCTAssertNil(routes)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetRoutesWithError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getRoutes(1) { (routes, error) in
            XCTAssertNil(routes)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

}
