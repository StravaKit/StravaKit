//
//  RequestorTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/9/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class RequestorTests: XCTestCase {

    let server = JSONServer()
    var requestor: Requestor = DefaultRequestor()
    let BaseURL: String = "http://localhost:8081"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if !server.isStarted {
            Strava.isDebugging = true
            requestor.baseUrl = BaseURL
            server.start()
        }

        Strava.sharedInstance.athlete = nil
        Strava.sharedInstance.accessToken = nil
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/data", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                XCTAssertNil(error, "Error must be nil")

                if let response = response,
                    let json = response as? JSONDictionary {
                    if let data = json["data"] as? String {
                        XCTAssertEqual(data, "123")
                    }
                    else {
                        XCTFail("Data is expected")
                    }
                }
                else {
                    XCTFail("Data is expected")
                }

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testAuthenticatedWithoutAccessTokenRequest() {
        let expectation = expectationWithDescription("Request")

        XCTAssertFalse(Strava.isAuthorized)

        requestor.request(.GET, authenticated: true, path: "/data", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testPostRequest() {
        let expectation = expectationWithDescription("Request")

        let params: [String : String] = [
            "data" : "123"
        ]

        requestor.request(.POST, authenticated: false, path: "/post", params: params) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                XCTAssertNotNil(response)
                XCTAssertNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testPostRequestWithBadParameters() {
        let expectation = expectationWithDescription("Request")

        let params: ParamsDictionary = [:]

        requestor.request(.POST, authenticated: false, path: "/post", params: params) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                XCTAssertNotNil(response)
                XCTAssertNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testPutRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.PUT, authenticated: false, path: "/put", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                XCTAssertNotNil(response)
                XCTAssertNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testBadRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/bad-request", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testUnauthorizedRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/unauthorized", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testForbiddenRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/forbidden", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testNotFoundRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/not-found", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNotNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testServerErrorRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/server-error", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                debugPrint("Error: \(error)")
                debugPrint("Response: \(response)")
                XCTAssertNotNil(response)
                XCTAssertNotNil(error)

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testRateLimitRequest() {
        let expectation = expectationWithDescription("Request")

        requestor.request(.GET, authenticated: false, path: "/rate-limit", params: nil) { (response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                XCTAssertNil(response)
                XCTAssertNotNil(error)

                if let error = error,
                    let limit = error.userInfo[RateLimitLimitKey] as? String,
                    let usage = error.userInfo[RateLimitUsageKey] as? String {
                    debugPrint("Limit: \(limit)")
                    debugPrint("Usage: \(usage)")

                    XCTAssertEqual(limit, "100")
                    XCTAssertEqual(usage, "1000")
                }
                else {
                    XCTFail()
                }

                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

}
