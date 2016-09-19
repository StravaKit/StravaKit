#!/bin/sh

jazzy \
  --clean \
  --author StravaKit \
  --author_url https://github.com/brennanMKE/StravaKit \
  --github_url https://github.com/brennanMKE/StravaKit \
  --module-version 0.5.3 \
  --xcodebuild-arguments -scheme,StravaKit-iOS \
  --module StravaKit \
  --root-url https://stravakit.github.io/docs/swift/0.5.3/api/ \
  --output Documentation

