# StravaKit

API client for Strava written in Swift.

![](Strava.png)

## CocoaPods

[StravaKit](https://github.com/brennanMKE/StravaKit) is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'StravaKit'
```

## Carthage

StravaKit can also be built using [Carthage](https://github.com/carthage/carthage). 

Add the following line to your Cartfile:

```sh
github "brennanMKE/StravaKit" ~> 0.0
```

## Docs

[Strava Labs](http://labs.strava.com/developers/) provides an [API Reference](http://strava.github.io/api/). It includes specifications for working with OAuth and the various REST endpoints. Discussions on the API can be found in the [Developer Forum](https://groups.google.com/d/forum/strava-api).

## Contributions

Assistance with adding new functionality, fix a bug or report a bug is welcome. For new functionality you can browse the `To Do List` for missing features and once you've decided what you'd like to add you can create a new issue to let others know you are going to be preparing an update. Fork the main repository, prepare your update with tests and submit a `Pull Request`. For bugs, if you plan on fixing them yourself, please also fork the repository, include tests and submit a `Pull Request`. If you've discovered a bug place create a new issue. It is possible the issue has already been logged so look before adding a new issue.

 * [To Do List](TODO.md)
 * [GitHub Issues](https://github.com/brennanMKE/StravaKit/issues)

## Purpose and Goals

The StravaKit framework is meanted to be a Swift implementation of a Strava API client. The goal is to make it fully functional so that it can be used to build any iOS or potentially Mac, Apple TV or watchOS app. Dependencies will be kept at a minimum. While StravaKit will be made available via CocoaPods and Carthage, it will not have any dependencies itself. It will also not load in UIKit so that it will be possible to use for developing a Mac app.

## License

MIT

## Author

Brennan Stehling - 2016
