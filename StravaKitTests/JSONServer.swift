//
//  JSONServer.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/9/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation
import Swifter
import StravaKit

internal class JSONServer {
    let server = HttpServer()
    var isStarted: Bool = false

    internal func prepare() {
        server["/data"] = { request in
            return .OK(.Json(["data" : "123"]))
        }

        server.POST["/post"] = { request in
            return .OK(.Json(["posted" : "true"]))
        }

        server.PUT["/put"] = { request in
            return .OK(.Json(["put" : "true"]))
        }

        server["/bad-request"] = { request in
            return .BadRequest(.Html("Bad Request"))
        }

        server["/unauthorized"] = { request in
            return .Unauthorized
        }

        server["/forbidden"] = { request in
            return .Forbidden
        }

        server["/not-found"] = { request in
            return .NotFound
        }

        server["/server-error"] = { request in
            return .InternalServerError
        }

        server["/rate-limit"] = { request in
            let statusCode: Int = 403
            let headers: [String : String] = [
                "Content-Type" : "application/json",
                RateLimitLimitHeaderKey : "100",
                RateLimitUsageHeaderKey : "1000"
            ]

            if let data = JSONLoader.sharedInstance.loadData("rate-limit"),
                let string = String(data: data, encoding: NSUTF8StringEncoding) {
                return HttpResponse.RAW(statusCode, "Rate Limit", headers, { $0.write([UInt8](string.utf8)) })
            }

            return .InternalServerError
        }

    }

    internal func start() {
        prepare()
        do {
            try server.start(8081)
            isStarted = true
        }
        catch {
            // deal with it
        }
    }

    internal func stop() {
        server.stop()
        isStarted = false
    }

}
