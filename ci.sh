#!/usr/bin/env bash

set -e

xctool -project StravaKit.xcodeproj -scheme StravaDemo -destination "platform=iOS Simulator,name=iPhone 6" test -test-sdk iphonesimulator9.3
