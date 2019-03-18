#
# Be sure to run `pod lib lint YSBannerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YSBannerView'
  s.version          = '1.0.0'
  s.summary          = '使用简单、功能丰富、无依赖的 iOS图片、文字轮播器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
使用简单、功能丰富、无依赖的 **iOS图片、文字轮播器**，基于 `UICollectionView` 实现。
                       DESC

  s.homepage         = 'https://github.com/kysonyangs/YSBannerView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kysonyangs' => 'kysonyangs@gmail.com' }
  s.source           = { :git => 'https://github.com/kysonyangs/YSBannerView.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YSBannerView/Classes/**/*'

  # s.resource_bundles = {
  #   'YSBannerView' => ['YSBannerView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
