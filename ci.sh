#!/usr/bin/env bash

set -e
set -o pipefail

xcodebuild -project StravaKit.xcodeproj -scheme StravaDemo -destination "platform=iOS Simulator,name=iPhone 5s" build test
