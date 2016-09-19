#!/bin/sh

jazzy \
  --clean \
  --author StravaKit \
  --author_url https://github.com/brennanMKE/StravaKit \
  --github_url https://github.com/brennanMKE/StravaKit \
  --module-version 0.6.0 \
  --xcodebuild-arguments -scheme,StravaKit-iOS \
  --module StravaKit \
  --root-url https://stravakit.github.io/docs/swift/0.6.0/api/ \
  --output Documentation
