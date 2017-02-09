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
        if let s = JSONSupport(dictionary: dictionary),
            let mapId: String = s.value("id"),
            let summaryPolyline: String = s.value("summary_polyline"),
            let resourceState: Int = s.value("resource_state") {

            self.mapId = mapId
            self.summaryPolyline = summaryPolyline
            self.resourceState = resourceState

            // Optional Properties

            self.polyline = s.value("polyline", required: false)
        }
        else {
            return nil
        }
    }

    public var coordinates: [CLLocationCoordinate2D]? {
        if let polyline = polyline,
            let coordinates = Polyline.decodePolyline(polyline) {
            return coordinates
        }
        return nil
    }

    public var summaryCoordinates: [CLLocationCoordinate2D] {
        let polyline = Polyline.decodePolyline(summaryPolyline)
        if let polyline = polyline {
            return polyline
        }
        return []
    }

}
