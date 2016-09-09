//
//  StravaRoute.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/7/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum RouteResourcePath: String {
    case Routes = "/api/v3/athletes/:id/routes"
    case RouteDetail = "/api/v3/routes/:id"
}

public extension Strava {

    /**
     Gets route detail.

     ```swift
     Strava.getRoute(1) { (route, error) in }
     ```

     Docs: http://strava.github.io/api/v3/routes/#retreive
     */
    static func getRoute(routeId: Int, completionHandler:((route: Route?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = RouteResourcePath.RouteDetail.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(routeId))

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(route: nil, error: error)
                }
                return
            }

            handleRouteResponse(response, completionHandler: completionHandler)
        }
    }

    /**
     Gets routes for athlete by ID.

     ```swift
     Strava.getRoutes { (routes, error) in }
     ```

     Docs: http://strava.github.io/api/v3/routes/#list
     */
    static func getRoutes(athleteId: Int, page: Page? = nil, completionHandler:((clubs: [Route]?, error: NSError?) -> ())?) -> NSURLSessionTask? {
        let path = RouteResourcePath.Routes.rawValue.stringByReplacingOccurrencesOfString(":id", withString: String(athleteId))

        var params: ParamsDictionary? = nil
        if let page = page {
            params = [
                PageKey: page.page,
                PerPageKey: page.perPage
            ]
        }

        return request(.GET, authenticated: true, path: path, params: params) { (response, error) in
            if let error = error {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler?(clubs: nil, error: error)
                }
                return
            }

            handleRoutesResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleRouteResponse(response: AnyObject?, completionHandler:((route: Route?, error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let route = Route(dictionary: dictionary) {
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(route: route, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(route: nil, error: error)
            }
        }
    }

    internal static func handleRoutesResponse(response: AnyObject?, completionHandler:((routes: [Route]?, error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let routes = Route.routes(dictionaries)
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler?(routes: routes, error: nil)
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                let error = Strava.error(.InvalidResponse, reason: "Invalid Response")
                completionHandler?(routes: nil, error: error)
            }
        }
    }

}
