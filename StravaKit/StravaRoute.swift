//
//  StravaRoute.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/7/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum RouteResourcePath: String {
    case Route = "/api/v3/athletes/:id/routes"
    case RouteDetail = "/api/v3/routes/:route_id"
}

public extension Strava {

    // List of routes
    // http://strava.github.io/api/v3/routes/#list

    // Route detail
    // http://strava.github.io/api/v3/routes/#retreive

}
