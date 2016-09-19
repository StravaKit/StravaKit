Pod::Spec.new do |s|
  s.name             = "StravaKit"
  s.version          = "0.6.0"
  s.summary          = "API client for Strava written in Swift."
  s.description      = "Strava framework for interacting with the Strava API."
  s.module_name      = "StravaKit"
  s.homepage         = "https://github.com/brennanMKE/StravaKit"
  s.license          = 'MIT'
  s.author           = { "Brennan Stehling" => "brennan@smallsharptools.com" }
  s.source           = { :git => "https://github.com/brennanMKE/StravaKit.git", :tag => "v0.6.0" }
  s.social_media_url = 'https://twitter.com/smallsharptools'
  s.ios.deployment_target = '9.0'
  s.source_files = 'StravaKit/*.swift'
  s.cocoapods_version = '>= 1.0'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.frameworks = 'Foundation', 'CoreLocation', 'Security'
end