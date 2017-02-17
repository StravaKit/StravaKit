Pod::Spec.new do |s|
  s.name             = "StravaKit"
  s.version          = "0.9.4"
  s.summary          = "API client for Strava written in Swift."
  s.description      = "Swift framework for integrating with the Strava API."
  s.module_name      = "StravaKit"
  s.homepage         = "https://github.com/StravaKit/StravaKit"
  s.license          = 'MIT'
  s.author           = { "Brennan Stehling" => "brennan@smallsharptools.com" }
  s.source           = { :git => "https://github.com/StravaKit/StravaKit.git", :tag => "v0.9.4" }
  s.social_media_url = 'https://twitter.com/smallsharptools'
  s.source_files = 'Sources/*.swift'
  s.cocoapods_version = '>= 1.0'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.frameworks = 'Foundation', 'CoreLocation', 'Security'
end