//
//  ResourceSummary.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/**
 Model Representation of a resource summary.
 */
public struct ResourceSummary {
    let resourceId: Int
    let resourceState: Int

    /**
     Failable initializer.
     */
    init?(dictionary: JSONDictionary) {
        if let s = JSONSupport(dictionary: dictionary),
            let resourceId: Int = s.value("id"),
            let resourceState: Int = s.value("resource_state") {
            self.resourceId = resourceId
            self.resourceState = resourceState
        }
        else {
            return nil
        }
    }

}
