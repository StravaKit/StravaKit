# StravaKit 

![MIT Licence](https://img.shields.io/badge/license-MIT-blue.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/StravaKit.svg)](https://img.shields.io/cocoapods/v/StravaKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/StravaKit.svg?style=flat)](http://cocoadocs.org/docsets/StravaKit)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=57c228cc05a6640100b2f79c&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/57c228cc05a6640100b2f79c/build/latest)

API client for Strava written in Swift.

![](Strava.png)

See [CHANGELOG](CHANGELOG.md) and [TODO](TODO.md) for completed features and future plans.

## CocoaPods

[StravaKit](https://github.com/brennanMKE/StravaKit) is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'StravaKit', '~> 0.3'
```

## Carthage

StravaKit can also be built using [Carthage](https://github.com/carthage/carthage). 

Add the following line to your Cartfile:

```sh
github "brennanMKE/StravaKit" ~> 0.3
```

## Beta Status

While the StravaKit version is less than 1.0.0 it is considered beta. Breaking changes will follow [Semantic Versioning](Semantic Versioning) standards with some caveats while it is still in beta. All versions in the 0.3.x series will be compatible while a bump to 0.4 or 0.5 may include breaking changes in model properties as those details are worked out. Once the version has reached 1.0.0 strict Semantic Versioning will be followed.

## Docs

[Strava Labs](http://labs.strava.com/developers/) provides an [API Reference](http://strava.github.io/api/). It includes specifications for working with OAuth and the various REST endpoints. Discussions on the API can be found in the [Developer Forum](https://groups.google.com/d/forum/strava-api).

## Contributions

Assistance with adding new functionality, fixing a bug or reporting a bug is welcome. For new functionality you can browse the `To Do List` for missing features and once you've decided what you'd like to add you can create a new issue to let others know you are going to be preparing an update. Fork the repository, prepare your update with tests and submit a `Pull Request`. For bugs, if you plan on fixing them yourself, please also fork the repository, include tests and submit a `Pull Request`. If you've discovered a bug please create a new issue and label it as a bug. It is possible the issue has already been logged so look before adding a new issue.

If there is a feature that you feel is important and would like it implemented sooner you can create an issue and invite others to comment on it and use the reactions feature to indicate that they also are interested in that feature. The feature requests with more positive reactions will get priority.

 * [To Do List](TODO.md)
 * [GitHub Issues](https://github.com/brennanMKE/StravaKit/issues)

## Purpose and Goals

The StravaKit framework is intended to be a Swift implementation of a Strava API client. The goal is to make it fully functional so that it can be used to build any iOS or potentially Mac, Apple TV or watchOS app. Dependencies will be kept at a minimum. While StravaKit will be made available via CocoaPods and Carthage, it will not have any dependencies itself. It will also not load in UIKit so that it will be possible to use for developing a Mac app.

StravaKit will also track with the current version of Swift once 3.0 is released without any priority for older versions of Swift or Objective-C and iOS releases. If an app requires older versions of iOS or Objective-C it is recommended to use [FRDStravaClient](https://github.com/sebastienwindal/FRDStravaClient) which is built with Objective-C and will be more appropriate for backward compatibility.

## Architecture

The response returned while authorizing access to the Strava API includes the access token and the athlete profile. While these values are stored in the Keychain, this framework does not provide other data store solutions. Either another entirely separate framework will be built on top of StravaKit or optional features will be defined as submodules. With CocoaPods it is possible to define subspecs. For Carthage and SPM submodules may not be supported currently. It may make most sense to create extension frameworks which work with StravaKit. A data store solution would use StravaKit and wrap all interactions with the API so the the app and view controllers would not directly interact with the API and would instead submit requests to the data store for what is needed and get a deferred result when the data is ready, either from locally stored data which is still fresh or after pulling a fresh copy from the API.

## License

MIT

## Author

Brennan Stehling - 2016

# Examples

A demo application is included with StravaKit along with a comprehensive collection of tests which demonstrate how StravaKit can be used.

### Authorizing with OAuth

Strava uses [OAuth 2.0](https://oauth.net/2/) for authorizing access to the API on behalf of the user. You will need to register your own application and get a Client ID and Client Secret to allow your app to use OAuth with Strava. For an iOS app the web view which is used is the Safari View Controller which gives the user access to their existing browser session outside your app. It will allow them to log into Strava more easily to allow for giving your app permission to get an access token. Once access has been granted the `redirectURI` will be used to open your app which must be configured with a URL Scheme. For the demo app the URL Scheme is defined in the `Info.plist` with a key named `CFBundleURLTypes`. You can copy this configuration and change the values to suit your app.

### User Login

Returns a URL which can be used to open the login web page for Strava.

```swift
let redirectURI = "stravademo://localhost/oauth/signin"
Strava.set(clientId: clientId, clientSecret: clientSecret, redirectURI: redirectURI)

if let URL = Strava.userLogin(scope: .Public) {
    let vc = SFSafariViewController(URL: URL, entersReaderIfAvailable: false)
    presentViewController(vc, animated: true, completion: nil)
    // hold onto the vc to dismiss later 
    self.safariViewController = vc
}
```

### Open URL

When the `redirectURI` is used it will cause a method in your `AppDelegate` to be run. The `openURL` method which is provided by StravaKit will determine if an opened URL should be used for OAuth authorization.

```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return Strava.openURL(url, sourceApplication: sourceApplication)
}
```

If the URL which opened the app includes a code to use for getting an access token it will be used and once it is successful a notification will be broadcast to indicate that it has completed. 

```swift
internal func stravaAuthorizationCompleted(notification: NSNotification?) {
    self.safariViewController?.dismissViewControllerAnimated(true, completion: nil)
    safariViewController = nil
    guard let userInfo = notification?.userInfo,
        let status = userInfo[StravaStatusKey] as? String else {
        return
    }
    if status == StravaStatusSuccessValue {
        self.statusLabel.text = "Authorization successful!"
    }
    else if let error = userInfo[StravaErrorKey] as? NSError {
        print("Error: \(error.localizedDescription)")
    }
}
```

### Deauthorize

Once the authorization steps have beenc completed successfully the access token and athlete profile have been securely stored in the user's Keychain for use whenever they use your app. If they ever want to remove the access token and athlete profile they can deauthorize their session with Strava.

```swift
Strava.deauthorize { (success, error) in
    if success {
        // TODO: change UI for authorized state
    }
    else {
        // TODO: warn user that deauthorization failed
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
```

With a valid access token, which is managed for you by StravaKit, you can use various API endpoints.

### Get Athlete

Fetches the profile for the currently authorized athlete.

```swift
Strava.getAthlete { (athlete, error) in }
```

### Get Athlete

Fetches an athlete profile using their ID.

```swift
Strava.getAthlete(athleteId) { (athlete, error) in }
```

### Get Athlete Friends

Fetches friends of hte current athlete.

```swift
Strava.getAthleteFriends { (athletes, error) in }
```

## Get Stats

Fetches stats for the currently authorized athlete. 

```swift
Strava.getStats(athleteId, completionHandler: { (stats, error) in }
```

### Get Activities

Fetches activities for the currently authorized athlete.

```swift
Strava.getActivities { (activities, error) in }
```

### Get Activity

Fetches activities for the currently authorized athlete.

```swift
Strava.getActivity(firstActivity.activityId, completionHandler: { (activity, error) in }
```

### Get Activities of Friends (Following)

Fetches activities for other athletes the current athlete is following.

```swift
Strava.getFollowingActivities { (activities, error) in }
```

### Get Club

Fetches details of a club given the ID.

```swift
Strava.getClub(1) { (club, error) in }
```

### Get Clubs for Current Athlete

Fetches clubs for the current athlete.

```swift
Strava.getClubs { (clubs, error) in }
```

### Get Segment Detail

Fetches segment detail by ID.

```swift
Strava.getSegment(1) { (segment, error) in }
```

### Get Segments in a bounded map area 

Fetches segments within a bounding box.

```swift
Strava.getSegments(mapBounds) { (segments, error) in }
```

### Get Starred Segments 

Fetches segments the current athlete has starred.

```swift
Strava.getStarredSegments() { (segments, error) in }
```

### Get Segment Leaderboard 

Fetches leaderboard for a segment.

```swift
Strava.getSegmentLeaderboard(1) { (leaderboard, error) in }
```

Not all endpoints have been implemented in StravaKit. See Contributions.
