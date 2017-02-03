//
//  JSONLoader.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal class JSONLoader : NSObject {

    static let sharedInstance: JSONLoader = JSONLoader()

    func loadJSON(_ name: String) -> Any? {
        let data = loadData(name)

        if let data = data {
            return try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }

        return nil
    }

    func loadData(_ name: String) -> Data? {
        let bundle = Bundle(for: classForCoder)
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        let fm = FileManager.default
        if fm.isReadableFile(atPath: path) {
            guard let data = fm.contents(atPath: path) else {
                return nil
            }

            return data
        }

        return nil
    }

}
