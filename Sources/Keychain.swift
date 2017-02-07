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

private let KnownErrSecMissingEntitlement = Int32(-34018)

public extension Strava {

    @discardableResult
    internal func storeAccessData() -> Bool {
        deleteAccessData()
        var success = false

        if let accessToken = accessToken,
            let athlete = athlete {

            let dictionary: JSONDictionary = [
                StravaAccessTokenKey : accessToken,
                StravaAthleteKey : athlete.dictionary
            ]

            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictionary)

            let query: JSONDictionary = [
                kSecClass as String : kSecClassGenericPassword,
                kSecAttrAccount as String : StravaKeychainAccount,
                kSecValueData as String : data,
                kSecAttrAccessible as String  : kSecAttrAccessibleAlways as String
            ]

            let resultCode = SecItemAdd(query as CFDictionary, nil)

            check(resultCode)

            success = resultCode == noErr
        }

        return success
    }

    @discardableResult
    internal func loadAccessData() -> Bool {
        var success = false

        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : StravaKeychainAccount,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]

        var result: AnyObject?

        let resultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        check(resultCode)

        if resultCode == noErr {
            if let data = result as? Data {
                if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? JSONDictionary,
                    let accessToken = dictionary[StravaAccessTokenKey] as? String,
                    let athleteDictionary = dictionary[StravaAthleteKey] as? JSONDictionary,
                    let athlete = Athlete(dictionary: athleteDictionary) {
                    self.accessToken = accessToken
                    self.athlete = athlete
                    success = true
                }
            }
        }

        return success
    }

    @discardableResult
    internal func deleteAccessData() -> Bool {
        let query: [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : StravaKeychainAccount
        ]

        let resultCode = SecItemDelete(query as CFDictionary)

        check(resultCode)

        return resultCode == noErr || resultCode == errSecItemNotFound
    }

    internal func check(_ resultCode: OSStatus) {
        if resultCode == KnownErrSecMissingEntitlement {
            debugPrint("App is missing a critical entitlement. Add KeyChain Entitlement, Go to project settings -> Capabilities -> Keychain Sharing -> Add Keychain Groups+Turn On. See http://sstools.co/2ftrv0x")
        }
    }

}
