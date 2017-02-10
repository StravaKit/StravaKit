//
//  MapBounds.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Model Representation of map bounds.
 */
public struct MapBounds {
    public let coordinate1: CLLocationCoordinate2D
    public let coordinate2: CLLocationCoordinate2D

    /**
     Failable initializer.
     */
    public init?(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) {
        if CLLocationCoordinate2DIsValid(coordinate1) && CLLocationCoordinate2DIsValid(coordinate2) {
            self.coordinate1 = coordinate1
            self.coordinate2 = coordinate2
        }
        else {
            return nil
        }
    }

    /**
     Failable initializer.
     */
    public init?(latitude1: CLLocationDegrees, longitude1: CLLocationDegrees, latitude2: CLLocationDegrees, longitude2: CLLocationDegrees) {
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        self.init(coordinate1: coordinate1, coordinate2: coordinate2)
    }

}
