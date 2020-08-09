#
# Be sure to run `pod lib lint AlertyNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlertyNetwork'
  s.version          = '1.0.0'
  s.summary          = 'An awful library created to show alert messages depending network connectivity.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Observe network connectivity to show messages.
                       DESC

  s.homepage         = 'https://github.com/emrcftci/AlertyNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'emrcftci' => 'emreciftci541@gmail.com' }
  s.source           = { :git => 'https://github.com/emrcftci/AlertyNetwork.git', :tag => 1.0.0 }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AlertyNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AlertyNetwork' => ['AlertyNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReachabilitySwift', '~> 5.0.0'
  s.dependency 'SwiftMessages', '~> 8.0.0'
end
