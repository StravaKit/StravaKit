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

    private let precision: Double = 0.00001

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let mapId: String = s.value("id"),
            let summaryPolyline: String = s.value("summary_polyline"),
            let resourceState: Int = s.value("resource_state") else {
                return nil
        }

        self.mapId = mapId
        self.summaryPolyline = summaryPolyline
        self.resourceState = resourceState

        // Optional Properties

        self.polyline = s.value("polyline", required: false)
    }

    public var coordinates: [CLLocationCoordinate2D]? {
        if let polyline = polyline {
            let p = Polyline(encodedPolyline: polyline)
            return p.coordinates
        }
        return nil
    }

    public var summaryCoordinates: [CLLocationCoordinate2D] {
        let polyline = Polyline(encodedPolyline: summaryPolyline)
        return polyline.coordinates ?? []
    }

}
