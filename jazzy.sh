#!/bin/sh

jazzy \
  --clean \
  --author StravaKit \
  --author_url https://github.com/StravaKit/StravaKit \
  --github_url https://github.com/StravaKit/StravaKit \
  --module-version 0.7.0 \
  --xcodebuild-arguments -scheme,StravaKit-iOS \
  --module StravaKit \
  --root-url https://stravakit.github.io/docs/swift/0.7.0/api/ \
  --output Documentation
