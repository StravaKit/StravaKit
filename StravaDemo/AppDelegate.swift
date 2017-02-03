//
//  AppDelegate.swift
//  StravaDemo
//
//  Created by Brennan Stehling on 8/18/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import UIKit
import StravaKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return Strava.openURL(url, sourceApplication: sourceApplication)
    }

}

