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

    func loadJSON(name: String) -> AnyObject? {
        let data = loadData(name)

        if let data = data {
            return try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        }

        return nil
    }

    func loadData(name: String) -> NSData? {
        let bundle = NSBundle(forClass: self.classForCoder)
        guard let path = bundle.pathForResource(name, ofType: "json") else {
            return nil
        }
        let fm = NSFileManager.defaultManager()
        if fm.isReadableFileAtPath(path) {
            guard let data = fm.contentsAtPath(path) else {
                return nil
            }

            return data
        }

        return nil
    }

}