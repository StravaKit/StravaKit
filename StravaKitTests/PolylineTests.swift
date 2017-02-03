//
//  PolylineTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

internal struct Coordinate {
    let latitude: Double
    let longitude: Double

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double {
            self.latitude = latitude
            self.longitude = longitude
        }
        else {
            return nil
        }
    }

    static func coordinates(_ json: JSONArray) -> [Coordinate] {
        var result: [Coordinate] = []

        for dictionary in json {
            if let coordinate = Coordinate(dictionary: dictionary) {
                result.append(coordinate)
            }
        }

        return result
    }
}

internal struct PolylineData {
    let polyline: String
    let coordinates: [Coordinate]

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let polyline = dictionary["polyline"] as? String,
            let coordinatesDictionary = dictionary["coordinates"] as? JSONArray {
            let coordinates = Coordinate.coordinates(coordinatesDictionary)
            self.polyline = polyline
            self.coordinates = coordinates
        }
        else {
            return nil
        }
    }

    static func loadJSONData(_ json: JSONArray) -> [PolylineData] {
        var items: [PolylineData] = []
        for dictionary in json {
            if let data = PolylineData(dictionary: dictionary) {
                items.append(data)
            }
        }

        return items
    }
}

class PolylineTests: XCTestCase {

    func testPolylines() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)
        let epsilon = Double(FLT_EPSILON)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.characters.count > 0)
            XCTAssertTrue(polylineData.coordinates.count > 0)
            let coordinates = Polyline.decodePolyline(polylineData.polyline)
            XCTAssertNotNil(coordinates)
            XCTAssertTrue(coordinates?.count == polylineData.coordinates.count)
            if let coordinates = coordinates {
                for (index, coordinate) in coordinates.enumerated() {
                    let otherCoordinate = polylineData.coordinates[index]
                    XCTAssertEqualWithAccuracy(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: epsilon)
                    XCTAssertEqualWithAccuracy(coordinate.longitude, otherCoordinate.longitude, accuracy: epsilon)
                }
            }
        }
    }

    func testMapIncomplete() {
        let dictionary: JSONDictionary = [
            "id": "a1",
            "resource_state": 3
        ]

        let map = Map(dictionary: dictionary)

        XCTAssertNil(map)
    }

    func testMapCoordinatesSummary() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)
        let epsilon = Double(FLT_EPSILON)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.characters.count > 0)
            XCTAssertTrue(polylineData.coordinates.count > 0)

            let dictionary: JSONDictionary = [
                "id": "a1",
                "summary_polyline": polylineData.polyline,
                "resource_state": 3
            ]

            guard let map = Map(dictionary: dictionary) else {
                XCTFail()
                return
            }

            XCTAssertNil(map.coordinates)
            XCTAssertNotNil(map.summaryCoordinates)

            for (index, coordinate) in map.summaryCoordinates.enumerated() {
                let otherCoordinate = polylineData.coordinates[index]
                XCTAssertEqualWithAccuracy(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: epsilon)
                XCTAssertEqualWithAccuracy(coordinate.longitude, otherCoordinate.longitude, accuracy: epsilon)
            }
        }
    }

    func testMapCoordinatesFull() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)
        let epsilon = Double(FLT_EPSILON)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.characters.count > 0)
            XCTAssertTrue(polylineData.coordinates.count > 0)

            let dictionary: JSONDictionary = [
                "id": "a1",
                "polyline": polylineData.polyline,
                "summary_polyline": polylineData.polyline,
                "resource_state": 3
            ]

            guard let map = Map(dictionary: dictionary) else {
                XCTFail()
                return
            }

            XCTAssertNotNil(map.coordinates)
            XCTAssertNotNil(map.summaryCoordinates)

            if let coordinates = map.coordinates {
                for (index, coordinate) in coordinates.enumerated() {
                    let otherCoordinate = polylineData.coordinates[index]
                    XCTAssertEqualWithAccuracy(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: epsilon)
                    XCTAssertEqualWithAccuracy(coordinate.longitude, otherCoordinate.longitude, accuracy: epsilon)
                }
            }
            
        }
    }

}
