//
//  Keychain.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/22/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import Foundation

internal let StravaKeychainAccount: String = "StravaKit"
internal let StravaAccessTokenKey: String = "access_token"
internal let StravaAthleteKey: String = "athlete"

public extension Strava {

    // MARK: Keychain Access

    internal func storeAccessData() -> Bool {
        deleteAccessData()

        if let accessToken = accessToken,
            let athlete = athlete {

            let dictionary: [String : AnyObject] = [
                StravaAccessTokenKey : accessToken,
                StravaAthleteKey : athlete.dictionary
            ]

            let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionary)

            let query: [String : AnyObject] = [
                kSecClass as String : kSecClassGenericPassword,
                kSecAttrAccount as String : StravaKeychainAccount,
                kSecValueData as String : data,
                kSecAttrAccessible as String  : kSecAttrAccessibleAlways as String
            ]

            let resultCode = SecItemAdd(query as CFDictionary, nil)
            return resultCode == noErr
        }

        return false
    }

    internal func loadAccessData() -> Bool {
        let query: [String: AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : StravaKeychainAccount,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]

        var result: AnyObject?

        let resultCode = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCode == noErr {
            if let data = result as? NSData {
                if let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String : AnyObject],
                    let accessToken = dictionary[StravaAccessTokenKey] as? String,
                    let athleteDictionary = dictionary[StravaAthleteKey] as? [String : AnyObject],
                    let athlete = Athlete(dictionary: athleteDictionary) {
                    self.accessToken = accessToken
                    self.athlete = athlete
                    return true
                }
            }
        }

        return false
    }

    internal func deleteAccessData() -> Bool {
        let query: [String: AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : StravaKeychainAccount
        ]
        
        let resultCode = SecItemDelete(query as CFDictionary)
        
        return resultCode == noErr
    }

}
