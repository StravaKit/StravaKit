//
//  StravaRoute.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/7/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public enum RouteResourcePath: String {
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
    @discardableResult
    public static func getRoute(_ routeId: Int, completionHandler:((_ route: Route?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = replaceId(id: routeId, in: RouteResourcePath.RouteDetail.rawValue)

        return request(.GET, authenticated: true, path: path, params: nil) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
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
    @discardableResult
    public static func getRoutes(_ athleteId: Int, page: Page? = nil, completionHandler:((_ clubs: [Route]?, _ error: NSError?) -> ())?) -> URLSessionTask? {
        let path = replaceId(id: athleteId, in: RouteResourcePath.Routes.rawValue)
        var params: ParamsDictionary? = nil
        if let page = page {
            params = [
                PageKey: page.page,
                PerPageKey: page.perPage
            ]
        }

        return request(.GET, authenticated: true, path: path, params: params) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleRoutesResponse(response, completionHandler: completionHandler)
        }
    }

    // MARK: - Internal Functions -

    internal static func handleRouteResponse(_ response: Any?, completionHandler:((_ route: Route?, _ error: NSError?) -> ())?) {
        if let dictionary = response as? JSONDictionary,
            let route = Route(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(route, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

    internal static func handleRoutesResponse(_ response: Any?, completionHandler:((_ routes: [Route]?, _ error: NSError?) -> ())?) {
        if let dictionaries = response as? JSONArray {
            let routes = Route.routes(dictionaries)
            DispatchQueue.main.async {
                completionHandler?(routes, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }

}
