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
import CoreLocation

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

        navigationItem.titleView = UIImageView(image: StravaStyleKit.imageOfTitleLogo())

        loadDefaults()
        refreshUI()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.stravaAuthorizationCompleted(_:)), name: StravaAuthorizationCompletedNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: StravaAuthorizationCompletedNotification, object: nil)
    }

    // MARK: - User Actions -

    @IBAction func accessButtonTapped(sender: AnyObject) {
        if !Strava.isAuthorized {
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
        let isAuthorized = Strava.isAuthorized
        let title = isAuthorized ? "Deauthorize" : "Authorize"
        statusLabel.text = nil
        accessButton.setTitle(title, forState: .Normal)
        runTestsButton.hidden = !isAuthorized
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
                debugPrint("Deauthorization successful!")
            }
            else {
                // TODO: warn user
                if let error = error {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    internal func stravaAuthorizationCompleted(notification: NSNotification?) {
        assert(NSThread.isMainThread(), "Main Thread is required")
        safariViewController?.dismissViewControllerAnimated(true, completion: nil)
        safariViewController = nil
        refreshUI()
        guard let userInfo = notification?.userInfo,
            let status = userInfo[StravaStatusKey] as? String else {
                debugPrint("🔥🔥🔥")
                return
        }
        if status == StravaStatusSuccessValue {
            self.statusLabel.text = "Authorization successful!"
        }
        else if let error = userInfo[StravaErrorKey] as? NSError {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }

    internal func runTests() {
        Strava.isDebugging = true
        let total: Int = 13

        // reset test count
        testCount = 0
        statusLabel.text = "Running Tests"

        getAthlete { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Athlete", error: error)
        }
        getAthleteByID { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Athlete by ID", error: error)
        }
        getAthleteFriends { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Athlete Friends", error: error)
        }
        getStats { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Stats", error: error)
        }
        getActivities { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Activities", error: error)
        }
        getFollowingActivities { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Following Activities", error: error)
        }
        getClub { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Club", error: error)
        }
        getClubs { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Clubs", error: error)
        }
        getSegment { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Segment", error: error)
        }
        getSegments { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Segments", error: error)
        }
        getStarredSegments { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Starred Segments", error: error)
        }
        getSegmentLeaderboard { (success, error) in
            self.handleTestResult(success, total: total, name: "Get Segment Leaderboard", error: error)
        }
        getSegmentEfforts{ (success, error) in
            self.handleTestResult(success, total: total, name: "Get Segment Leaderboard", error: error)
        }
    }

    internal func handleTestResult(success: Bool, total: Int, name: String, error: NSError?) {
        if success {
            testCount += 1
            if testCount == total {
                showIntegrationResult(true)
            }
        }
        else {
            if let error = error {
                debugPrint("Error with \(name): \(error.localizedDescription)")
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

    internal func getAthleteFriends(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getAthleteFriends { (athletes, error) in
            if let _ = athletes {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
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

    internal func getClub(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getClub(1000) { (club, error) in
            if let _ = club {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getClubs(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getClubs { (clubs, error) in
            if let _ = clubs {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getSegment(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getSegment(141491) { (clubs, error) in
            if let _ = clubs {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getSegments(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        let latitude1: CLLocationDegrees = 37.821362
        let longitude1: CLLocationDegrees = -122.505373
        let latitude2: CLLocationDegrees = 37.842038
        let longitude2: CLLocationDegrees = -122.465977
        let coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1)
        let coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2)

        guard let mapBounds = MapBounds(coordinate1: coordinate1, coordinate2: coordinate2) else {
            let error = NSError(domain: "Testing", code: 1, userInfo: nil)
            completionHandler(success: false, error: error)
            return
        }

        Strava.getSegments(mapBounds) { (segments, error) in
            if let _ = segments {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getStarredSegments(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getStarredSegments { (segments, error) in
            if let _ = segments {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getSegmentLeaderboard(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getSegmentLeaderboard(141491) { (leaderboard, error) in
            if let _ = leaderboard {
                completionHandler(success: true, error: nil)
            }
            else if let error = error {
                completionHandler(success: false, error: error)
            }
        }
    }

    internal func getSegmentEfforts(completionHandler: ((success: Bool, error: NSError?) -> ())) {
        Strava.getSegmentEfforts(141491) { (efforts, error) in
            if let _ = efforts {
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
