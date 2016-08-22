//
//  StravaAtheleteTests.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/21/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import XCTest

@testable import StravaKit

class StravaAtheleteTests: XCTestCase {

    func testAthleteCreationFromGoodDictionary() {
        // all required values are in the JSON file
        guard let dictionary = athleteDictionary("athlete-good") else {
            XCTFail()
            return
        }

        let athlete = Athlete.athlete(dictionary)
        XCTAssertNotNil(athlete)
    }

    func testAthleteCreationFromBadDictionary() {
        // required values are missing from the JSON file
        guard let dictionary = athleteDictionary("athlete-bad") else {
            XCTFail()
            return
        }

        let athlete = Athlete.athlete(dictionary)
        XCTAssertNil(athlete)
    }

    func testAthleteDictionary() {
        // all required values are in the JSON file
        guard let dictionary = athleteDictionary("athlete-good") else {
            XCTFail()
            return
        }

        guard let athlete = Athlete.athlete(dictionary),
            let otherAthlete = Athlete.athlete(athlete.dictionary) else {
                XCTFail()
                return
        }
        XCTAssertTrue(athlete.firstName == otherAthlete.firstName)
        XCTAssertTrue(athlete.lastName == otherAthlete.lastName)
        XCTAssertTrue(athlete.city == otherAthlete.city)
        XCTAssertTrue(athlete.state == otherAthlete.state)
        XCTAssertTrue(athlete.country == otherAthlete.country)
        XCTAssertTrue(athlete.email == otherAthlete.email)
    }


    func testAthleteCreationFromOtherDictionary() {
        // other athlete JSON which is not as full
        guard let dictionary = athleteDictionary("athlete-other") else {
            XCTFail()
            return
        }

        let athlete = Athlete.athlete(dictionary)
        XCTAssertNotNil(athlete)
    }

    // MARK: Private

    private func athleteDictionary(name: String) -> [String : AnyObject]? {
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
