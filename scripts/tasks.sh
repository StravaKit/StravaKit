#!/bin/sh

set -e

Command="$1"

AppVersion="0.8.0"
ProjectName="StravaKit"
ProjectDir="`dirname \"$0\"`"
Workspace="${ProjectName}.xcworkspace"
Scheme="${ProjectName}-iOS"
Project="${ProjectName}.xcodeproj"
Target="${ProjectName}-iOS"

TestPlatform="iOS Simulator"
TestName="iPhone 7"
TestOS="10.1"
TestDestination="platform=${TestPlatform},name=${TestName},OS=${TestOS}"

Configuration="Debug"

# No Integrate in Podfile (if you prefer not to use a workspace)
# install! 'cocoapods', :integrate_targets => false

run_build() {
    if [ "" == "${Workspace}" ]; then
        echo "Building Project..."
        xcodebuild -project "${Project}" -target "${Target}" -configuration "${Configuration}" build
    else
        echo "Building Workspace..."
        xcodebuild -workspace "${Workspace}" -scheme "${Scheme}" -configuration "${Configuration}" build
    fi
}

run_tests() {
    if [ "" == "${Workspace}" ]; then
        echo "Testing Project..."
        xcodebuild -project "${Project}" -scheme "${Scheme}" -destination "${TestDestination}" test | bundle exec xcpretty --test --color
    else
        echo "Testing Workspace..."
        xcodebuild -workspace "${Workspace}" -scheme "${Scheme}" -destination "${TestDestination}" test | bundle exec xcpretty --test --color
    fi
}

run_clean() {
    if [ "" == "${Workspace}" ]; then
        echo "Cleaning Project..."
        xcodebuild -project "${Project}" -target "${Target}" -configuration "${Configuration}" clean
    else
        echo "Cleaning Workspace..."
        xcodebuild -workspace "${Workspace}" -scheme "${Scheme}" -configuration "${Configuration}" clean
    fi
}

run_jazzy() {
    jazzy \
        --clean \
        --author StravaKit \
        --author_url https://github.com/StravaKit/StravaKit \
        --github_url https://github.com/StravaKit/StravaKit \
        --module-version ${AppVersion} \
        --xcodebuild-arguments -scheme,StravaKit-iOS \
        --module StravaKit \
        --root-url http://cocoadocs.org/docsets/StravaKit/${AppVersion}/ \
        --output Documentation
}



run_bundle_install() {
    echo "Installing Gems..."
    bundle install
}

run_pod_install() {
    echo "Installing Pods..."
    bundle exec pod install
}

run_pod_update() {
    echo "Updating Pods..."
    bundle exec pod update
}

run_pod_spec_lint() {
    echo "Linting Podspec..."
    bundle exec pod spec lint
}

run_pod_trunk_push() {
    echo "Linting Podspec..."
    bundle exec pod trunk push
}

run_setup() {
    echo "Setting up..."
    run_bundle_install
    run_pod_install
}

run_all() {
    echo "Setting up..."
    run_clean
    run_bundle_install
    run_pod_install
    run_build
    run_tests
}

case "${Command}" in
    build)
        run_build
        ;;
    test)
        run_tests
        ;;
    clean)
        run_clean
        ;;
    jazzy)
        run_jazzy
        ;;
    setup)
        run_setup
        ;;
    all)
        run_all
        ;;
    bundle-install)
        run_bundle_install
        ;;
    pod-install)
        run_pod_install
        ;;
    pod-update)
        run_pod_update
        ;;
    pod-spec-lint)
        run_pod_spec_lint
        ;;
    pod-trunk-push)
        run_pod_trunk_push
        ;;
    *)
        echo "Usage: `basename $0` { build | clean | jazzy | setup | all | bundle-install | pod-install | pod-update | pod-spec-lint | pod-trunk-push }"
        ;;
esac
