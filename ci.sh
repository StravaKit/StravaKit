#!/usr/bin/env bash

set -e

# xctool -project StravaKit.xcodeproj -scheme StravaDemo -destination "platform=iOS Simulator,name=iPhone 6" test -test-sdk iphonesimulator9.3

# xcodebuild -project StravaKit.xcodeproj -scheme StravaDemo -destination "platform=iOS Simulator,name=iPhone 6" test 

xcodebuild -project StravaKit.xcodeproj -scheme StravaDemo -configuration Debug -sdk iphonesimulator9.3 -destination "platform=iOS Simulator,name=iPhone 6" test -enableCodeCoverage YES
