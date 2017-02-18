//
//  StravaUpload.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal enum UploadResourcePath: String {
    case Upload = "/api/v3/uploads"
    case CheckUpload = "/api/v3/uploads/:id"
}

public extension Strava {
    @discardableResult
    public static func upload(_ activity: UploadActivity, completionHandler:((_ status: UploadStatus?, _ error: NSError?) -> ())?) -> URLSessionTask? {

        let path = UploadResourcePath.Upload.rawValue

        return uploadRequest(path, activity.dictionary, activity.file) { (response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                return
            }

            handleUploadResponse(response, completionHandler: completionHandler)
        }

    }

    internal static func handleUploadResponse(_ response: Any?, completionHandler:((_ status: UploadStatus?, _ error: NSError?) -> ())?) {

        if let dictionary = response as? JSONDictionary,
            let status = UploadStatus(dictionary: dictionary) {
            DispatchQueue.main.async {
                completionHandler?(status, nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let error = Strava.error(.invalidResponse, reason: "Invalid Response")
                completionHandler?(nil, error)
            }
        }
    }
}
