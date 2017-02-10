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
            return .ok(.json(["data" : "123"] as AnyObject))
        }

        server.POST["/post"] = { request in
            return .ok(.json(["posted" : "true"] as AnyObject))
        }

        server.PUT["/put"] = { request in
            return .ok(.json(["put" : "true"] as AnyObject))
        }

        server["/bad-request"] = { request in
            return .badRequest(.html("Bad Request"))
        }

        server["/unauthorized"] = { request in
            return .unauthorized
        }

        server["/forbidden"] = { request in
            return .forbidden
        }

        server["/not-found"] = { request in
            return .notFound
        }

        server["/server-error"] = { request in
            return .internalServerError
        }

        server["/rate-limit"] = { request in
            let statusCode: Int = 403
            let headers: [String : String] = [
                "Content-Type" : "application/json",
                RateLimitLimitHeaderKey : "100",
                RateLimitUsageHeaderKey : "1000"
            ]

            if let data = JSONLoader.sharedInstance.loadData("rate-limit"),
                let string = String(data: data, encoding: String.Encoding.utf8) {
                return HttpResponse.raw(statusCode, "Rate Limit", headers, {
                    do {
                        try $0.write([UInt8](string.utf8))
                    }
                    catch {
                        fatalError()
                    }
                })
            }

            return .internalServerError
        }

    }

    internal func start() {
        if isStarted {
            return
        }
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
