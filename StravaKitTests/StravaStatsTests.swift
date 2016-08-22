//
//  StravaStatsTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaStatsTests: XCTestCase {
    
    func testAthleteCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = statsDictionary("stats-good") else {
            XCTFail()
            return
        }

        let stats = Stats.stats(1, dictionary: dictionary)
        XCTAssertNotNil(stats)
    }

    func testAthleteCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = statsDictionary("stats-bad") else {
            XCTFail()
            return
        }

        let stats = Stats.stats(1, dictionary: dictionary)
        XCTAssertNil(stats)
    }
    
    // MARK: Private

    private func statsDictionary(name: String) -> [String : AnyObject]? {
        let bundle = NSBundle(forClass: self.classForCoder)
        guard let path = bundle.pathForResource(name, ofType: "json") else {
            return nil
        }
        let fm = NSFileManager.defaultManager()
        if fm.isReadableFileAtPath(path) {
            guard let data = fm.contentsAtPath(path) else {
                return nil
            }
            do {
                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    return dictionary
                }
            }
            catch {
                // do nothing
            }
        }

        return nil
    }

}
