//
//  StravaSegmentTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
import CoreLocation

@testable import StravaKit

class StravaSegmentTests: XCTestCase {

    func testSegmentCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segment-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let segment = Segment(dictionary: dictionary)
        XCTAssertNotNil(segment)
        if let segment = segment {
            XCTAssertNil(segment.coordinates)
            XCTAssertNil(segment.starredDate)
            XCTAssertNotNil(segment.createdAt)
            XCTAssertNotNil(segment.updatedAt)
            XCTAssertNotNil(segment.athleteSegmentStats)
            if let stats = segment.athleteSegmentStats {
                XCTAssertNil(stats.prDate)
                XCTAssertNil(stats.prElapsedTime)
            }
        }
    }

    func testSegmentCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segment-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let segment = Segment(dictionary: dictionary)
        XCTAssertNil(segment)
    }

    func testSegmentsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segments-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let segments = Segment.segments(dictionary)
        XCTAssertNotNil(segments)
        if let segments = segments {
            debugPrint("Count: \(segments.count)")
            XCTAssertTrue(segments.count == 10)

            for segment in segments {
                XCTAssertNotNil(segment.coordinates)
                if segment.starred {
                    XCTAssertNotNil(segment.starredDate)
                }
                else {
                    XCTAssertNil(segment.starredDate)
                }
                if let stats = segment.athleteSegmentStats {
                    XCTAssertNotNil(stats.prDate)
                    XCTAssertNotNil(stats.prElapsedTime)
                }
            }
        }
    }

    func testSegmentsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segments-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let segments = Segment.segments(dictionary)
        XCTAssertNotNil(segments)
        XCTAssertEqual(segments?.count, 0)
    }

    func testSegmentsCreationFromEmptyArray() {
        let dictionary: JSONDictionary = ["segments" : []]
        let segments = Segment.segments(dictionary)
        XCTAssertNil(segments)
    }

    func testStarredSegmentsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("segments-starred-good") as? JSONArray else {
            XCTFail()
            return
        }

        let segments = Segment.segments(dictionaries)
        XCTAssertNotNil(segments)
        if let segments = segments {
            debugPrint("Count: \(segments.count)")
            XCTAssertTrue(segments.count == 4)
        }
    }

    func testStarredSegmentsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("segments-starred-bad") as? JSONArray else {
            XCTFail()
            return
        }

        let segments = Segment.segments(dictionaries)
        XCTAssertNotNil(segments)
        XCTAssertEqual(segments?.count, 0)
    }

    func testLeaderboardCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segment-leaderboard-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let leaderboard = Leaderboard(dictionary: dictionary)
        XCTAssertNotNil(leaderboard)
    }

    func testLeaderboardCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("segment-leaderboard-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let leaderboard = Leaderboard(dictionary: dictionary)
        XCTAssertNil(leaderboard)
    }

    func testSegmentEffortsCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("segment-efforts-good") as? JSONArray else {
            XCTFail()
            return
        }

        let efforts = SegmentEffort.efforts(dictionaries)
        debugPrint("Count: \(efforts.count)")
        XCTAssertTrue(efforts.count == 3)
        for effort in efforts {
            XCTAssertNotNil(effort.startDate)
            XCTAssertNotNil(effort.startDateLocal)
        }
    }

    func testSegmentEffortsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = JSONLoader.sharedInstance.loadJSON("segment-efforts-bad") as? JSONArray else {
            XCTFail()
            return
        }

        let efforts = SegmentEffort.efforts(dictionaries)
        XCTAssertEqual(efforts.count, 0)
    }

    func testSegmentStatsCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("empty") as? JSONDictionary else {
            XCTFail()
            return
        }

        let segmentStats = SegmentStats(dictionary: dictionary)
        XCTAssertNil(segmentStats)
    }

    func testResoureSummaryGood() {
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("resource-summary-good") as? JSONDictionary else {
            XCTFail()
            return
        }

        let resource = ResourceSummary(dictionary: dictionary)
        XCTAssertNotNil(resource)
    }

    func testResoureSummaryBad() {
        guard let dictionary = JSONLoader.sharedInstance.loadJSON("resource-summary-bad") as? JSONDictionary else {
            XCTFail()
            return
        }

        let resource = ResourceSummary(dictionary: dictionary)
        XCTAssertNil(resource)
    }

    func testGetSegmentGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegment(1) { (segment, error) in
            XCTAssertNotNil(segment)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegment(1) { (segment, error) in
            XCTAssertNil(segment)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegment(1) { (segment, error) in
            XCTAssertNil(segment)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentsGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segments-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            XCTFail()
            return
        }

        let page = Page(page: 1, perPage: 20)

        Strava.getSegments(mapBounds, page: page) { (segments, error) in
            XCTAssertNotNil(segments)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentsBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segments-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            XCTFail()
            return
        }

        Strava.getSegments(mapBounds) { (segments, error) in
            XCTAssertTrue(segments?.count == 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentsInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            XCTFail()
            return
        }

        Strava.getSegments(mapBounds) { (segments, error) in
            XCTAssertNil(segments)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }
    
    func testGetSegmentsError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            XCTFail()
            return
        }

        Strava.getSegments(mapBounds) { (segments, error) in
            XCTAssertNil(segments)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStarredSegmentsGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segments-starred-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getStarredSegments(page) { (segments, error) in
            XCTAssertNotNil(segments)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStarredSegmentsBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segments-starred-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getStarredSegments() { (segments, error) in
            XCTAssertTrue(segments?.count == 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStarredSegmentsInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getStarredSegments(page) { (segments, error) in
            XCTAssertNil(segments)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetStarredSegmentsError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getStarredSegments() { (segments, error) in
            XCTAssertNil(segments)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetLeaderboardGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-leaderboard-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getSegmentLeaderboard(1, page: page) { (leaderboard, error) in
            XCTAssertNotNil(leaderboard)
            XCTAssertNotNil(leaderboard?.entries)
            if let entries = leaderboard?.entries {
                for entry in entries {
                    XCTAssertNotNil(entry.startDate)
                    XCTAssertNotNil(entry.startDateLocal)
                }
            }
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetLeaderboardBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-leaderboard-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegmentLeaderboard(1) { (leaderboard, error) in
            XCTAssertNil(leaderboard)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetLeaderboardInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getSegmentLeaderboard(1, page: page) { (leaderboard, error) in
            XCTAssertNil(leaderboard)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetLeaderboardError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegmentLeaderboard(1) { (leaderboard, error) in
            XCTAssertNil(leaderboard)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentEffortsGood() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-efforts-good")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getSegmentEfforts(1, page: page) { (efforts, error) in
            XCTAssertNotNil(efforts)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentEffortsBad() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("segment-efforts-bad")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegmentEfforts(1) { (efforts, error) in
            XCTAssertNotNil(efforts)
            XCTAssertTrue(efforts?.count == 0)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentEffortsInvalid() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = JSONLoader.sharedInstance.loadJSON("invalid")
        jsonRequestor.error = nil
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        let page = Page(page: 1, perPage: 20)

        Strava.getSegmentEfforts(1, page: page) { (efforts, error) in
            XCTAssertNil(efforts)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testGetSegmentEffortsError() {
        let expectation = self.expectationWithDescription("API Call")

        let jsonRequestor = JSONRequestor()
        jsonRequestor.response = nil
        jsonRequestor.error = NSError(domain: "Testing", code: 500, userInfo: nil)
        Strava.sharedInstance.alternateRequestor = jsonRequestor

        Strava.getSegmentEfforts(1) { (efforts, error) in
            XCTAssertNil(efforts)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 120
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

}
