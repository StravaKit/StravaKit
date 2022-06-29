//
//  Zones.swift
//  StravaKit
//
//  Created by Brennan Stehling on 1/18/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct Zone {

    /// Max value.
    public let max: Int
    /// Min value.
    public let min: Int

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let max: Int = s.value("max"),
            let min: Int = s.value("min") else {
                return nil
        }
        self.max = max
        self.min = min
    }

    public static func zones(_ array: JSONArray) -> [Zone]? {
        let zones = array.compactMap { (d) in
            return Zone(dictionary: d)
        }

        return zones.count > 0 ? zones : nil
    }

}

public struct ZoneCollection {

    // Indicates if athlete has set their own custom heart rate zones.
    public let custom: Bool

    // Zones.
    public let zones: [Zone]

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let custom: Bool = s.value("custom_zones", required: false, nilValue: false),
            let zonesArray: JSONArray = s.value("zones"), zonesArray.count > 0,
            let zones = Zone.zones(zonesArray) else {
                return nil
        }
        self.custom = custom
        self.zones = zones
    }

}

/**
 Model Representation of zones.
 */
public struct Zones {

    // Heart rate zones.
    public let heartRate: ZoneCollection?

    // Power zones.
    public let power: ZoneCollection?

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        // try loading the zone collection for heart rate and power
        if let heartRateDictionary = dictionary["heart_rate"] as? JSONDictionary {
            heartRate = ZoneCollection(dictionary: heartRateDictionary)
        }
        else {
            heartRate = nil
        }
        if let powerDictionary = dictionary["power"] as? JSONDictionary {
            power = ZoneCollection(dictionary: powerDictionary)
        }
        else {
            power = nil
        }
        if heartRate == nil && power == nil {
            return nil
        }
    }

}
