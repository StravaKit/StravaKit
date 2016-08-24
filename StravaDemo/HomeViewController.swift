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

    // MARK: - Properties -

    @IBOutlet weak var clientIdTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    @IBOutlet weak var accessButton: UIButton!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var getAthleteButton: UIButton!
    @IBOutlet weak var getAthleteByIDButton: UIButton!
    @IBOutlet weak var getStatsButton: UIButton!

    var safariViewController: SFSafariViewController? = nil

    // MARK: - Private Constants -

    private let ClientIDKey: String = "ClientID"
    private let ClientSecretKey: String = "ClientSecret"

    // MARK: - Computed Properties -

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

    // MARK: - View Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        loadDefaults()
        refreshUI()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.stravaSignInCompleted(_:)), name: StravaAuthorizationCompletedNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: StravaAuthorizationCompletedNotification, object: nil)
    }

    // MARK: - User Actions -

    @IBAction func accessButtonTapped(sender: AnyObject) {
        if !Strava.isAuthenticated {
            authorizeStrava()
        }
        else {
            deauthorizeStrava()
        }
    }

    @IBAction func getAthleteTapped(sender: AnyObject) {
        getAthelete()
    }

    @IBAction func getAthleteByIDButtonTapped(sender: AnyObject) {
        getAtheleteByID()
    }

    @IBAction func getStatsButtonTapped(sender: AnyObject) {
        getStats()
    }

    // MARK: - Internal Functions -

    internal func refreshUI() {
        assert(NSThread.isMainThread(), "Main Thread is required")
        let isAuthenticated = Strava.isAuthenticated
        let title = isAuthenticated ? "Deauthorize" : "Authorize"
        statusLabel.text = nil
        accessButton.setTitle(title, forState: .Normal)
        getAthleteButton.hidden = !isAuthenticated
        getAthleteByIDButton.hidden = !isAuthenticated
        getStatsButton.hidden = !isAuthenticated
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
            self.refreshUI()
            if success {
                print("Deauthorization successful!")
            }
            else {
                // TODO: warn user
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    internal func stravaSignInCompleted(notification: NSNotification?) {
        assert(NSThread.isMainThread(), "Main Thread is required")
        safariViewController?.dismissViewControllerAnimated(true, completion: nil)
        refreshUI()
        if let userInfo = notification?.userInfo {
            if let status = userInfo[StravaStatusKey] as? String {
                if status == StravaStatusSuccessValue {
                    print("Authorization successful!")
                    if let athlete = Strava.currentAthlete {
                        print("Athlete: \(athlete.fullName)")
                    }
                }
                else if let error = userInfo[StravaErrorKey] as? NSError {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    internal func getAthelete() {
        Strava.getAthlete { (athlete, error) in
            if let athlete = athlete {
                self.statusLabel.text = "Loaded Athlete: \(athlete.fullName)"
                print("\(athlete.fullName)")
            }
            else if let error = error {
                self.statusLabel.text = error.localizedDescription
            }
        }
    }

    internal func getAtheleteByID() {
        if let athleteId = Strava.currentAthlete?.athleteId {
            Strava.getAthlete(athleteId) { (athlete, error) in
                if let athlete = athlete {
                    self.statusLabel.text = "Loaded Athlete by ID: \(athlete.fullName)"
                    print("\(athlete.fullName)")
                }
                else if let error = error {
                    self.statusLabel.text = error.localizedDescription
                }
            }
        }
    }

    internal func getStats() {
        if let athleteId = Strava.currentAthlete?.athleteId {
            Strava.getStats(athleteId, completionHandler: { (stats, error) in
                if let stats = stats {
                    self.statusLabel.text = "Loaded Stats: \(stats.athleteId)"
                    print("\(athleteId)")
                }
                else if let error = error {
                    self.statusLabel.text = error.localizedDescription
                }
            })
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
