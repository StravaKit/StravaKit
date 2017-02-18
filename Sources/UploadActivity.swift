//
//  UploadActivity.swift
//  StravaKit
//
//  Created by Chris Kimber on 15/02/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public enum UploadActivityDataType: String {
    case fit = "fit",
        fitgz = "fit.gz",
        tcx = "tcx",
        tcxgz = "tcx.gx",
        gpx = "gpx",
        gpxgz = "gpx.gz"
}

public enum UploadActivityType: String {
    case ride = "ride",
        run = "run",
        swim = "swim",
        workout = "workout",
        hike = "hike",
        walk = "walk",
        nordicski = "nordicski",
        alpineski = "alpineski",
        backcountryski = "backcountryski",
        iceskate = "iceskate",
        inlineskate = "inlineskate",
        kitesurf = "kitesurf",
        rollerski = "rollerski",
        windsurf = "windsurf",
        snowboard = "snowboard",
        snowshoe = "snowshoe",
        ebikeride = "ebikeride",
        virtualride = "virtualride"
}

public struct UploadActivity {
    public var activityType: UploadActivityType? = nil
    public var name: String? = nil
    public var description: String? = nil
    public var isPrivate: Int? = nil
    public var trainer: Int? = nil
    public var commute: Int? = nil
    public let dataType: UploadActivityDataType
    public var externalId: String? = nil
    public let file: Data

    public init(_ dataType: UploadActivityDataType, _ file: Data) {
        self.dataType = dataType
        self.file = file
    }

    public var dictionary: JSONDictionary {
        let dictionary: JSONDictionary = [
            "data_type": self.dataType.rawValue
        ]
        return dictionary
    }
}
