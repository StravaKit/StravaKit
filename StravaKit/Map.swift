//
//  Map.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/26/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Model Representation of a map.
 */
public struct Map {
    public let mapId: String
    public let polyline: String?
    public let summaryPolyline: String
    public let resourceState: Int

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let mapId = dictionary["id"] as? String,
            let summaryPolyline = dictionary["summary_polyline"] as? String,
            let resourceState = dictionary["resource_state"] as? Int {

            self.mapId = mapId
            self.summaryPolyline = summaryPolyline
            self.resourceState = resourceState
            // Note: The polyline property is not included in all API responses
            if let polyline = dictionary["polyline"] as? String {
                self.polyline = polyline
            }
            else {
                self.polyline = nil
            }
        }
        else {
            return nil
        }
    }

    public var coordinates: [CLLocationCoordinate2D]? {
        get {
            if let polyline = polyline,
                let coordinates = Polyline.decodePolyline(polyline) {
                return coordinates
            }
            return nil
        }
    }

    public var summaryCoordinates: [CLLocationCoordinate2D] {
        get {
            let polyline = Polyline.decodePolyline(summaryPolyline)
            if let polyline = polyline {
                return polyline
            }
            return []
        }
    }
    
}