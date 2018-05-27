project 'FlickrViperArchitecture.xcodeproj'

platform :ios, '9.1'
source 'https://github.com/CocoaPods/Specs.git'
inhibit_all_warnings!
use_frameworks!

target 'FlickrViperArchitecture' do

  use_frameworks!

  plugin 'cocoapods-keys', {
    :project => "FlickrViperArchitecture",
    :target => "FlickrViperArchitecture",
    :keys => [
      "FlickrApiKey",
      "FlickrSecretKey"
  ]}

  pod 'SDWebImage'

  target 'FlickrViperArchitectureTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FlickrViperArchitectureUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
