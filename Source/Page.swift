//
//  Page.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

/** Page Key */
public let PageKey: String = "page"
/** Per Page Key */
public let PerPageKey: String = "per_page"

/**
 Model Representation of a page.
 */
public struct Page {
    let page: Int
    let perPage: Int
}
