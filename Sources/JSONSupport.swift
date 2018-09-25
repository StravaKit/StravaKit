//
//  JSONSupport.swift
//  StravaKit
//
//  Created by Brennan Stehling on 9/8/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/** 
  JSONSupport provides parsing and debugging support for JSON data. Values can
  be treated as required with an optional value to set if the given value is nil.
  If a value is required and debugging is enabled with the `JSONDebuggingEnabled`
  environment variable warnings will be printed to help pinpoint the problem.
 */
internal class JSONSupport {

    fileprivate let dictionary: JSONDictionary

    init?(dictionary: JSONDictionary) {
        self.dictionary = dictionary
    }

    func isJSONDebuggingEnabled() -> Bool {
        return ProcessInfo.processInfo.environment["JSONDebuggingEnabled"]?.uppercased() == "YES"
    }

    func value<T>(_ key: String, required: Bool = true, nilValue: T? = nil) -> T? {
        var warnings: [String] = []
        if required && isJSONDebuggingEnabled() {
            if let _ : T = cast(dictionary[key]) {
                // No warnings
            }
            else if dictionary[key] == nil {
                warnings.append("Dictionary value is missing: \(key)")
            }
            else {
                warnings.append("Dictionary value is wrong type: \(key), \(String(describing: dictionary[key]))")
            }

            for warning in warnings {
                debugPrint(warning)
            }
        }
        guard let value: T = cast(dictionary[key]) else {
            return nilValue
        }
        return value
    }

    private func cast<T>(_ value: Any?) -> T? {
        if let value = value as? T {
            return value
        }
        if let value = value as? NSNumber {
            if T.self == Float.self || T.self == Float?.self {
                return value.floatValue as? T
            }
            if T.self == Double.self || T.self == Double?.self {
                return value.doubleValue as? T
            }
            if T.self == Int.self || T.self == Int?.self {
                return value.intValue as? T
            }
        }
        
        return nil
    }
}
