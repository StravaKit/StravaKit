#!/usr/bin/env bash

set -e

xcodebuild -project StravaKit.xcodeproj -scheme "StravaDemo" -destination "platform=iOS Simulator,name=iPhone 6" test
