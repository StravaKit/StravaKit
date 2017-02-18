//
//  UploadStatus.swift
//  StravaKit
//
//  Created by Chris Kimber on 15/02/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

public struct UploadStatus {
    public let id: Int
    public let externalId: String
    public var activityId: Int?
    public let status: String
    public var error: String?

    init?(dictionary: JSONDictionary) {
        guard let s = JSONSupport(dictionary: dictionary),
            let id: Int = s.value("id"),
            let externalId: String = s.value("external_id"),
            let status: String = s.value("status")
            else {
                return nil
        }

        self.id = id
        self.externalId = externalId
        self.status = status

        self.activityId = s.value("activity_id", required: false)
        self.error = s.value("error", required: false)
    }
}
