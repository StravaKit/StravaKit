//
//  HomeViewController.swift
//  StravaKit
//
//  Created by Brennan Stehling on 8/20/16.
//  Copyright © 2016 SmallSharpTools LLC. All rights reserved.
//

import UIKit
import StravaKit
import SafariServices

class HomeViewController: UIViewController {

    @IBOutlet weak var clientIdTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    @IBOutlet weak var accessButton: UIButton!

    var safariViewController: SFSafariViewController? = nil

    private let ClientIDKey : String = "ClientID"
    private let ClientSecretKey : String = "ClientSecret"

    var clientId : String {
        get {
            if let string = clientIdTextField.text {
                return string
            }
            return ""
        }
        set {
            clientIdTextField.text = newValue
        }
    }

    var clientSecret : String {
        get {
            if let string = clientSecretTextField.text {
                return string
            }
            return ""
        }
        set {
            clientSecretTextField.text = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDefaults()
        refreshAccessButton()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.stravaSignInCompleted(_:)), name: StravaAuthorizationCompletedNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: StravaAuthorizationCompletedNotification, object: nil)
    }

    @IBAction func accessButtonTapped(sender: AnyObject) {
        if !Strava.isAuthenticated {
            authorizeStrava()
        }
        else {
            deauthorizeStrava()
        }
    }

    // MARK: Internal Functions

    internal func refreshAccessButton() {
        assert(NSThread.isMainThread(), "Main Thread is required")
        let title = Strava.isAuthenticated ? "Deauthorize" : "Authorize"
        accessButton.setTitle(title, forState: .Normal)
    }

    internal func authorizeStrava() {
        storeDefaults()
        let redirectURI = "stravademo://localhost/oauth/signin"
        Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)

        if let URL = Strava.userLogin(scope: .Public, state: "") {
            let vc = SFSafariViewController(URL: URL, entersReaderIfAvailable: false)
            presentViewController(vc, animated: true, completion: nil)
            safariViewController = vc
        }
    }

    internal func deauthorizeStrava() {
        Strava.deauthorize { (success, error) in
            assert(NSThread.isMainThread(), "Main Thread is required")
            self.refreshAccessButton()
            if success {
                print("Deauthorization successfull!")
            }
            else {
                // TODO: warn user
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }

    internal func stravaSignInCompleted(notification: NSNotification?) {
        assert(NSThread.isMainThread(), "Main Thread is required")
        safariViewController?.dismissViewControllerAnimated(true, completion: nil)
        refreshAccessButton()
        if let userInfo = notification?.userInfo {
            if let status = userInfo[StravaStatusKey] as? String {
                if status == StravaStatusSuccessValue {
                    print("Authorization successfull!")
                    if let athlete = Strava.currentAthlete {
                        print("Athlete: \(athlete.fullName)")
                    }
                }
                else if let error = userInfo[StravaErrorKey] as? NSError {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }

    internal func loadDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let clientId = defaults.objectForKey(ClientIDKey) as? String,
            let clientSecret = defaults.objectForKey(ClientSecretKey) as? String {
            self.clientId = clientId
            self.clientSecret = clientSecret
        }
    }

    internal func storeDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(clientId, forKey: ClientIDKey)
        defaults.setObject(clientSecret, forKey: ClientSecretKey)
    }

}
