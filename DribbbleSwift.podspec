#
# Be sure to run `pod lib lint DribbbleSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DribbbleSwift"
  s.version          = "0.1.0"
  s.summary          = "Swift wrapper for dribbble api v1"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Swift wrapper for dribbble api v1 http://developer.dribbble.com/v1/"

  s.homepage         = "https://github.com/gkye/DribbbleSwift"
  s.license          = 'MIT'
  s.author           = { "gkye" => "gkye@live.ca" }
s.source           = { :git => "https://github.com/gkye/DribbbleSwift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kyegeorge'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*'

end
