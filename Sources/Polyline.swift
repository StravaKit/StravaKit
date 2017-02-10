//
//  File.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//
// Credit: Raphaël Mor & Tom Taylor
// GitHub: https://github.com/raphaelmor/Polyline
// Docs: http://strava.github.io/api/#polylines

import Foundation
import CoreLocation

enum PolylineError: Error {
    case singleCoordinateDecodingError
    case chunkExtractingError
}

internal class Polyline {

    /**
     This function decodes a `String` to a `[CLLocationCoordinate2D]?`.

     @param encodedPolyline: `String` representing the encoded Polyline
     @param precision: The precision used to decode coordinates (default: `1e5`)

     @return: A `[CLLocationCoordinate2D]` representing the decoded polyline if valid, `nil` otherwise
     */
    internal static func decodePolyline(_ encodedPolyline: String, precision: Double = 1e5) -> [CLLocationCoordinate2D]? {
        guard let data: Data = encodedPolyline.data(using: String.Encoding.utf8)
            else {
            return nil
        }
        let byteArray: UnsafePointer<Int8> = unsafeBitCast((data as NSData).bytes, to: UnsafePointer<Int8>.self)
        let length: Int = Int(data.count)
        var position: Int = Int(0)

        var decodedCoordinates: [CLLocationCoordinate2D] = []

        var lat: Double = 0.0
        var lon: Double = 0.0

        while position < length {
            do {
                let resultingLat = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lat += resultingLat

                let resultingLon = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lon += resultingLon
            } catch {
                return nil
            }

            decodedCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }

        if decodedCoordinates.count > 0 {
            return decodedCoordinates
        }

        return nil
    }

    /**
     We use a byte array (UnsafePointer<Int8>) here for performance reasons. 
     Check with swift 2 if we can go back to using [Int8].
     */
    fileprivate static func decodeSingleCoordinate(byteArray: UnsafePointer<Int8>, length: Int, position: inout Int, precision: Double = 1e5) throws -> Double {

        guard position < length else { throw PolylineError.singleCoordinateDecodingError }

        let bitMask: Int8 = Int8(0x1F)

        var coordinate: Int32 = 0

        var currentChar: Int8
        var componentCounter: Int32 = 0
        var component: Int32 = 0

        repeat {
            currentChar = byteArray[position] - 63
            component = Int32(currentChar & bitMask)
            coordinate |= (component << (5*componentCounter))
            position += 1
            componentCounter += 1
        } while ((currentChar & 0x20) == 0x20) && (position < length) && (componentCounter < 6)

        if (componentCounter == 6) && ((currentChar & 0x20) == 0x20) {
            throw PolylineError.singleCoordinateDecodingError
        }

        if (coordinate & 0x01) == 0x01 {
            coordinate = ~(coordinate >> 1)
        } else {
            coordinate = coordinate >> 1
        }

        return Double(coordinate) / precision
    }

}
