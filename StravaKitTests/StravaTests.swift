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

    func testAddQueryParametersToNilURL() {
        let params = ["name" : "Tim"]
        let URL = Strava.appendQueryParameters(params, URL: nil)
        XCTAssertNil(URL)
    }

    func testURLCreationForValueURLString() {
        // valid URL string
        let URL = Strava.urlWithString(StravaBaseURL, parameters: nil)
        XCTAssertNotNil(URL)
    }

    func testURLCreationForBasicParameters() {
        // adding parameters
        let parameters : JSONDictionary = ["name" : "strava"]
        let URL = Strava.urlWithString(StravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            XCTAssertTrue(query.containsString("name=strava"))
        }
        else {
            XCTFail()
        }
    }

    func testURLCreationForIntParameter() {
        // add parameter which is an Int
        let parameters : JSONDictionary = ["name" : "strava", "score" : Int(5)]
        let URL = Strava.urlWithString(StravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
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
        let parameters : JSONDictionary = ["name" : "strava", "pi" : Double(3.14)]
        let URL = Strava.urlWithString(StravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
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
        let parameters : JSONDictionary = ["name" : "strava v3"]
        let URL = Strava.urlWithString(StravaBaseURL, parameters: parameters)
        XCTAssertNotNil(URL)
        if let URL = URL,
            let query = URL.query {
            XCTAssertTrue(query.containsString("name=strava%20v3"))
        }
        else {
            XCTFail()
        }
    }

    func testDateString() {
        let string = "2016-08-21T20:11:54Z"
        guard let timeZone = NSTimeZone(abbreviation: "GMT") else {
            XCTFail()
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"

        guard let date = dateFormatter.dateFromString(string) else {
            XCTFail()
            return
        }

        let unitFlags: NSCalendarUnit = [.Month, .Day, .Year, .Hour, .Minute, .Second, .TimeZone]
        let calendar = NSCalendar.currentCalendar()
        // Ensure the calendar uses the GMT time zone not the local time zone for the device
        calendar.timeZone = timeZone

        let components = calendar.components(unitFlags, fromDate: date)
        XCTAssertEqual(components.month, 8)
        XCTAssertEqual(components.day, 21)
        XCTAssertEqual(components.year, 2016)
        XCTAssertEqual(components.hour, 20)
        XCTAssertEqual(components.minute, 11)
        XCTAssertEqual(components.second, 54)
        if let tz = components.timeZone {
            XCTAssertTrue(tz.abbreviation == "GMT")
        }
    }

}
