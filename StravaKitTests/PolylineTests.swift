//
//  PolylineTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest
import CoreLocation

@testable import StravaKit

internal struct Coordinate {
    let latitude: Double
    let longitude: Double

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double else {
                return nil
        }
        self.latitude = latitude
        self.longitude = longitude
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
        guard let polyline = dictionary["polyline"] as? String,
            let coordinatesDictionary = dictionary["coordinates"] as? JSONArray else {
                return nil
        }
        let coordinates = Coordinate.coordinates(coordinatesDictionary)
        self.polyline = polyline
        self.coordinates = coordinates
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

    let precision: Double = 0.00001

    func loadCoordinates() -> (String, [CLLocationCoordinate2D])? {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            return nil
        }

        // Extract the encoded polyline and coordinates
        guard let encodedPolyline = json.first?["polyline"] as? String,
            let jsonCoordinates = json.first?["coordinates"] as? JSONArray else {
                return nil
        }

        let coordinates = jsonCoordinates.compactMap { (dictionary) -> CLLocationCoordinate2D? in
            if let latitude = dictionary["latitude"] as? Double,
                let longitude = dictionary["longitude"] as? Double {
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                return coordinate
            }
            return nil
        }

        return (encodedPolyline, coordinates)
    }

    func testPolylines() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.count > 0)
            XCTAssertTrue(polylineData.coordinates.count > 0)
            let polyline = Polyline(encodedPolyline:polylineData.polyline)
            let coordinates: [CLLocationCoordinate2D]? = polyline.coordinates
            XCTAssertNotNil(coordinates)
            XCTAssertTrue(coordinates?.count == polylineData.coordinates.count)
            if let coordinates = coordinates {
                for (index, coordinate) in coordinates.enumerated() {
                    let otherCoordinate = polylineData.coordinates[index]
                    XCTAssertEqual(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: precision)
                    XCTAssertEqual(coordinate.longitude, otherCoordinate.longitude, accuracy: precision)
                }
            }
        }
    }

    func testPolylineLevels() {
        let sut = Polyline(encodedPolyline: "", encodedLevels: "?@AB~F")

        if let resultArray = sut.levels {
            XCTAssertEqual(resultArray.count, 5)
            XCTAssertEqual(resultArray[0], UInt32(0))
            XCTAssertEqual(resultArray[1], UInt32(1))
            XCTAssertEqual(resultArray[2], UInt32(2))
            XCTAssertEqual(resultArray[3], UInt32(3))
            XCTAssertEqual(resultArray[4], UInt32(255))
        } else {
            XCTFail("Valid Levels should be decoded properly")
        }
    }

    func testPolylineWitEmptyCoordinates() {
        let sut = Polyline(coordinates: [])
        XCTAssertEqual(sut.encodedPolyline, "")
    }

    func testMapIncomplete() {
        let dictionary: JSONDictionary = [
            "id": "a1",
            "resource_state": 3
        ]

        let map = Map(dictionary: dictionary)

        XCTAssertNil(map)
    }

    func testPolylinesEncodingCoordinates() {
        guard let (encodedPolyline, coordinates) = loadCoordinates() else {
            XCTFail()
            return
        }

        let polyline = Polyline(coordinates: coordinates)
        print("Encoded Polyline: \(encodedPolyline)")
        XCTAssertEqual(encodedPolyline, polyline.encodedPolyline)
        XCTAssertEqual(polyline.locations?.count ?? 0, coordinates.count)
    }

    func testPolylinesEncodingLocations() {
        guard let (encodedPolyline, coordinates) = loadCoordinates() else {
            XCTFail()
            return
        }

        let locations = coordinates.compactMap { (coordinate) -> CLLocation? in
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }

        let polyline = Polyline(locations: locations)
        print("Encoded Polyline: \(encodedPolyline)")
        XCTAssertEqual(encodedPolyline, polyline.encodedPolyline)
    }

    func testMapCoordinatesSummary() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.count > 0)
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
                XCTAssertEqual(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: precision)
                XCTAssertEqual(coordinate.longitude, otherCoordinate.longitude, accuracy: precision)
            }
        }
    }

    func testMapCoordinatesFull() {
        guard let json = JSONLoader.sharedInstance.loadJSON("polylines") as? JSONArray else {
            XCTFail()
            return
        }

        let polylinesData = PolylineData.loadJSONData(json)

        for polylineData in polylinesData {
            XCTAssertTrue(polylineData.polyline.count > 0)
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
                    XCTAssertEqual(Double(coordinate.latitude), Double(otherCoordinate.latitude), accuracy: precision)
                    XCTAssertEqual(coordinate.longitude, otherCoordinate.longitude, accuracy: precision)
                }
            }
            
        }
    }

}
