//
//  JSONSupport.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/8/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal class JSONSupport {

    private let dictionary: JSONDictionary

    init?(dictionary: JSONDictionary) {
        self.dictionary = dictionary
    }

    func isJSONDebuggingEnabled() -> Bool {
        return NSProcessInfo.processInfo().environment["JSONDebuggingEnabled"] == "YES"
    }

    func value<T>(key: String, required: Bool = true, nilValue: T? = nil) -> T? {
        var warnings : [String] = []
        if required && isJSONDebuggingEnabled() {
            if let _ = dictionary[key] as? T {
                // No warnings
            }
            else if dictionary[key] == nil {
                warnings.append("Dictionary value is missing: \(key)")
            }
            else {
                warnings.append("Dictionary value is wrong type: \(key), \(dictionary[key])")
            }

            for warning in warnings {
                debugPrint(warning)
            }
        }

        let value = dictionary[key] as? T
        if value == nil {
            return nilValue
        }
        return value
    }

}
