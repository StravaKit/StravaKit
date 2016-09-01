//
//  Page.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/31/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public let PageKey: String = "page"
public let PerPageKey: String = "per_page"

public struct Page {
    let page: Int
    let perPage: Int
}
