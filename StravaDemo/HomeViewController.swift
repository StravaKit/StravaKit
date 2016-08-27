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
    @IBOutlet weak var runTestsButton: UIButton!

    var safariViewController: SFSafariViewController? = nil
    var testCount: Int = 0

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

        navigationItem.titleView = UIImageView(image: StravaStyleKit.imageOfTitleLogo)

        loadDefaults()
        refreshUI()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.stravaAuthorizationCompleted(_:)), name: StravaAuthorizationCompletedNotification, object: nil)
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

    @IBAction func runTestsButtonTapped(sender: AnyObject) {
        runTests()
    }

    // MARK: - UI Functions -

    internal func refreshUI() {
        assert(NSThread.isMainThread(), "Main Thread is required")
        let isAuthenticated = Strava.isAuthenticated
        let title = isAuthenticated ? "Deauthorize" : "Authorize"
        statusLabel.text = nil
        accessButton.setTitle(title, forState: .Normal)
        runTestsButton.hidden = !isAuthenticated
    }

    internal func showIntegrationResult(success: Bool) {
        statusLabel.text = success ? "Integration Passed" : "Integration Failed"
    }

    // MARK: - Integration Functions -

    internal func authorizeStrava() {
        storeDefaults()
        let redirectURI = "stravademo://localhost/oauth/signin"
        Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)

        if let URL = Strava.userLogin(scope: .Public) {
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

    internal func stravaAuthorizationCompleted(notification: NSNotification?) {
        assert(NSThread.isMainThread(), "Main Thread is required")
        safariViewController?.dismissViewControllerAnimated(true, completion: nil)
        refreshUI()
        if let userInfo = notification?.userInfo {
            if let status = userInfo[StravaStatusKey] as? String {
                if status == StravaStatusSuccessValue {
                    self.statusLabel.text = "Authorization successful!"
                }
                else if let error = userInfo[StravaErrorKey] as? NSError {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    internal func runTests() {
        let total: Int = 5

        // reset test count
        testCount = 0
        statusLabel.text = "Running Tests"

        getAthlete { (success, error) in
            self.handleTestResult(success, total: total, error: error)
        }
        getAthleteByID { (success, error) in
            self.handleTestResult(success, total: total, error: error)
        }
        getStats { (success, error) in
            self.handleTestResult(success, total: total, error: error)
        }
        getActivities { (success, error) in
            self.handleTestResult(success, total: total, error: error)
        }
        getFollowingActivities { (success, error) in
            self.handleTestResult(success, total: total, error: error)
        }
    }

    internal func handleTestResult(success: Bool, total: Int, error: NSError?) {
        if success {
            testCount += 1
            if testCount == total {
                showIntegrationResult(true)
            }
        }
        else {
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            showIntegrationResult(false)
        }
    }

    internal func getAthlete(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getAthlete { (athlete, error) in
            if let _ = athlete {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getAthleteByID(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        if let athleteId = Strava.currentAthlete?.athleteId {
            Strava.getAthlete(athleteId) { (athlete, error) in
                if let _ = athlete {
                    completionHandler(success: true, error: nil)
                }
                else if let error = error {
                    completionHandler(success: false, error: error)
                }
            }
        }
    }

    internal func getStats(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        if let athleteId = Strava.currentAthlete?.athleteId {
            Strava.getStats(athleteId, completionHandler: { (stats, error) in
                if let _ = stats {
                    completionHandler(success: true, error: nil)
                }
                else if let error = error {
                    completionHandler(success: false, error: error)
                }
            })
        }
    }

    internal func getActivities(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getActivities { (activities, error) in
            if let activities = activities,
                let firstActivity = activities.first {
                Strava.getActivity(firstActivity.activityId, completionHandler: { (activity, error) in
                    if let _ = activity {
                        completionHandler(success: true, error: nil)
                    }
                    else if let error = error {
                        completionHandler(success: false, error: error)
                    }
                })
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getFollowingActivities(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getFollowingActivities { (activities, error) in
            if let _ = activities {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    // MARK: - Defaults Functions -

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
