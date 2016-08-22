//
//  StravaClientTests.swift
//  StravaDemo
//
//  Created by Brennan Stehling on 8/20/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaClientTests: XCTestCase {

    func testURLCreationForNil() {
        // nil paramters
        let URL = Strava.urlWithString(nil, parameters: nil)
        XCTAssertNil(URL)
    }

    func testURLCreationForValueURLString() {
        // valid URL string
        let URL = Strava.urlWithString(Strava.stravaBaseURL, parameters: nil)
        XCTAssertNotNil(URL)
    }

    func testURLCreationForBasicParemeters() {
        // adding parameters
        let parameters : [String : AnyObject] = ["name" : "strava"]
        let URL = Strava.urlWithString(Strava.stravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            print("URL: \(URL.absoluteString)")
            print("Query: \(query)")
            XCTAssertTrue(query.containsString("name=strava"))
        }
        else {
            XCTFail()
        }
    }

    func testURLCreationForIntParameter() {
        // add parameter which is an Int
        let parameters : [String : AnyObject] = ["name" : "strava", "score" : Int(5)]
        let URL = Strava.urlWithString(Strava.stravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            print("URL: \(URL.absoluteString)")
            print("Query: \(query)")
            // Note: Order of query parameters is not guaranteed
            XCTAssertTrue(query.containsString("name=strava"))
            XCTAssertTrue(query.containsString("score=5"))
        }
        else {
            XCTFail()
        }
    }

    func testURLCreationForDoubleParameter() {
        // add parameter which is a Double
        let parameters : [String : AnyObject] = ["name" : "strava", "pi" : Double(3.14)]
        let URL = Strava.urlWithString(Strava.stravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            print("URL: \(URL.absoluteString)")
            print("Query: \(query)")
            // Note: Order of query parameters is not guaranteed
            XCTAssertTrue(query.containsString("name=strava"))
            XCTAssertTrue(query.containsString("pi=3.14"))
        }
        else {
            XCTFail()
        }
    }

    func testURLCreationForParameterWithSpace() {
        // adding parameter value which has a space
        let parameters : [String : AnyObject] = ["name" : "strava v3"]
        let URL = Strava.urlWithString(Strava.stravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            print("URL: \(URL.absoluteString)")
            print("Query: \(query)")
            XCTAssertTrue(query.containsString("name=strava%20v3"))
        }
        else {
            XCTFail()
        }
    }

}
