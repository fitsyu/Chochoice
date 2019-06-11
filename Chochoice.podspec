#
# Be sure to run `pod lib lint Chochoice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Chochoice'
  s.version          = '0.1.0'
  s.summary          = 'Ask a user with Multiple-Choices question with smile.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  
  Once, I was required to make a question with multiple choices.
  I thought it would be for that only time.
  Later I was finding my self facing that requirement once more time.
  I said to my self. We did this. Why we should do it again.
  
                       DESC

  s.homepage         = 'https://github.com/fitsyu/Chochoice'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fitsyu' => 'fitsyu2@gmail.com' }
  s.source           = { :git => 'https://github.com/fitsyu/Chochoice.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'Chochoice/Classes/**/*'
  
  s.resource_bundles = {
     'Chochoice' => ['Chochoice/**/*.storyboard']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  swift_versions = '5.0'
end
