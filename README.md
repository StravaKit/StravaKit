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
pod 'StravaKit', '~> 0.5'
```

## Carthage

StravaKit can also be built using [Carthage](https://github.com/carthage/carthage). 

Add the following line to your Cartfile:

```sh
github "brennanMKE/StravaKit" ~> 0.5
```

## Beta Status

While the StravaKit version is less than 1.0.0 it is considered beta. Breaking changes will follow [Semantic Versioning](http://semver.org) standards with some caveats while it is still in beta. All versions in the 0.5.x series will be compatible while a bump to 0.6 or 0.7 may include breaking changes in model properties as those details are worked out. Once the version has reached 1.0.0 strict Semantic Versioning will be followed.

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

A demo application is included with StravaKit along with a comprehensive collection of tests which demonstrate how StravaKit can be used. Refer to [Documentation](Documentation/index.html) for further details.

Note: Not all endpoints have been implemented in StravaKit. See Contributions.
