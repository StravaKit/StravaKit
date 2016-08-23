//
//  StravaActivityTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaActivityTests: XCTestCase {

    func testActivitiesCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionaries = activitiesDictionaries("activities-good") else {
            XCTFail()
            return
        }

        let activities = Activity.activities(dictionaries)
        XCTAssertNotNil(activities)
    }

    func testActivitiesCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionaries = activitiesDictionaries("activities-bad") else {
            XCTFail()
            return
        }

        let activities = Activity.activities(dictionaries)
        XCTAssertNil(activities)
    }

    // MARK: Private

    private func activitiesDictionaries(name: String) -> [JSONDictionary]? {
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
                if let dictionaries = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [JSONDictionary] {
                    return dictionaries
                }
            }
            catch {
                // do nothing
            }
        }

        return nil
    }


}
