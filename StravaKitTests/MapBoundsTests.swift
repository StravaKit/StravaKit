//
//  MapBoundsTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
import CoreLocation

@testable import StravaKit

class MapBoundsTests: XCTestCase {

    func testMapWithoutSummaryPolylinePoints() {
        let dictionary: JSONDictionary = [
            "id": "101",
            "resource_state" : 1,
            "summary_polyline" : ""
        ]

        let map = Map(dictionary: dictionary)

        XCTAssertNotNil(map)
        XCTAssertTrue(map?.summaryCoordinates.count == 0)
    }

    func testMapBoundsGood1() {
        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977

        let mapBounds = MapBounds(latitude1: latitude1, longitude1: longitude1, latitude2: latitude2, longitude2: longitude2)
        XCTAssertNotNil(mapBounds)
    }

    func testMapBoundsGood2() {
        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2)
        XCTAssertNotNil(mapBounds)
    }

    func testMapBoundsBad1() {
        let coordinate1 = kCLLocationCoordinate2DInvalid
        let coordinate2 = kCLLocationCoordinate2DInvalid

        let latitude1: CLLocationDegrees = coordinate1.latitude
        let longitude1: CLLocationDegrees = coordinate1.longitude
        let latitude2: CLLocationDegrees = coordinate2.latitude
        let longitude2: CLLocationDegrees = coordinate2.longitude

        let mapBounds = MapBounds(latitude1: latitude1, longitude1: longitude1, latitude2: latitude2, longitude2: longitude2)
        XCTAssertNil(mapBounds)
    }

    func testMapBoundsBad2() {
        let coordinate1 = kCLLocationCoordinate2DInvalid
        let coordinate2 = kCLLocationCoordinate2DInvalid

        let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2)
        XCTAssertNil(mapBounds)
    }

}
