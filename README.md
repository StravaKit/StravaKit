# StravaKit 

![MIT Licence](https://img.shields.io/badge/license-MIT-blue.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/StravaKit.svg)](https://img.shields.io/cocoapods/v/StravaKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/StravaKit.svg?style=flat)](http://cocoadocs.org/docsets/StravaKit)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=57c228cc05a6640100b2f79c&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/57c228cc05a6640100b2f79c/build/latest)

API client for Strava written in Swift.

![](Strava.png)

See [Change Log] and [To Do List] for completed features and future plans.

## CocoaPods

[StravaKit] is available through [CocoaPods]. To install it, simply add the following line to your Podfile:

```ruby
pod 'StravaKit', '~> 0.7'
```

## Carthage

StravaKit can also be built using [Carthage]. 

Add the following line to your Cartfile:

```sh
github "StravaKit/StravaKit" ~> 0.7
```

## Beta Status

While the StravaKit version is less than 1.0.0 it is considered beta. Breaking changes will follow [Semantic Versioning] standards with some exceptions while it is still in beta. All versions in the 0.5.x series will be compatible while a bump to 0.6 or 0.7 may include breaking changes in model properties as those details are worked out. Once the version has reached 1.0.0 strict Semantic Versioning will be followed.

## Docs

[Strava Labs] provides an [API Reference]. It includes specifications for working with OAuth and the various REST endpoints. Discussions on the API can be found in the [Developer Forum].

## Contributions

Assistance with adding new functionality, fixing a bug or reporting a bug is welcome. For new functionality you can browse the `To Do List` for missing features and once you've decided what you'd like to add you can create a new issue to let others know you are going to be preparing an update. Fork the repository, prepare your update with tests and submit a `Pull Request`. For bugs, if you plan on fixing them yourself, please also fork the repository, include tests and submit a `Pull Request`. If you've discovered a bug please create a new issue and label it as a bug. It is possible the issue has already been logged so look before adding a new issue.

If there is a feature that you feel is important and would like it implemented sooner you can create an issue and invite others to comment on it and use the reactions feature to indicate that they also are interested in that feature. The feature requests with more positive reactions will get priority.

 * [To Do List]
 * [GitHub Issues]

## Purpose and Goals

The StravaKit framework is intended to be a Swift implementation of a Strava API client. The goal is to make it fully functional so that it can be used to build any iOS or potentially Mac, Apple TV or watchOS app. Dependencies will be kept at a minimum. While StravaKit will be made available via CocoaPods and Carthage, it will not have any dependencies itself. It will also not load in UIKit so that it will be possible to use for developing a Mac app.

StravaKit will also track with the current version of Swift once 3.0 is released without any priority for older versions of Swift or Objective-C and iOS releases. If an app requires older versions of iOS or Objective-C it is recommended to use [FRDStravaClient] which is built with Objective-C and will be more appropriate for backward compatibility.

## Architecture

The response returned while authorizing access to the Strava API includes the access token and the athlete profile. While these values are stored in the Keychain, this framework does not provide other data store solutions. Either another entirely separate framework will be built on top of StravaKit or optional features will be defined as submodules. With CocoaPods it is possible to define subspecs. For Carthage and SwiftPM submodules may not be supported currently. It may make most sense to create extension frameworks which work with StravaKit. A data store solution would use StravaKit and wrap all interactions with the API so the app and view controllers would not directly interact with the API and would instead submit requests to the data store for what is needed and get a deferred result when the data is ready, either from locally stored data which is still fresh or after pulling a fresh copy from the API.

## License

MIT

## Author

Brennan Stehling - 2016

# Examples

A demo application is included with StravaKit along with a comprehensive collection of tests which demonstrate how StravaKit can be used. You can also browse the documentation which is generated using [Jazzy].

Note: Not all endpoints have been implemented in StravaKit. See Contributions.

---

[Change Log]: https://github.com/StravaKit/StravaKit/blob/master/CHANGELOG.md
[To Do List]: https://github.com/StravaKit/StravaKit/blob/master/TODO.md
[GitHub Issues]: https://github.com/StravaKit/StravaKit/issues
[StravaKit]: https://github.com/StravaKit/StravaKit
[CocoaPods]: http://cocoapods.org
[Carthage]: https://github.com/carthage/carthage
[Semantic Versioning]: http://semver.org
[Strava Labs]: http://labs.strava.com/developers/
[API Reference]: http://strava.github.io/api/
[Developer Forum]: https://groups.google.com/d/forum/strava-api
[FRDStravaClient]: https://github.com/sebastienwindal/FRDStravaClient
[Jazzy]: https://github.com/realm/jazzy