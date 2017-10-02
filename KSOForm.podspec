#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOForm'
  s.version          = '0.4.0'
  s.summary          = 'KSOForm is a iOS framework for creating Settings app like views.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  KSOForm is a iOS framework for creating Settings app like views. It manages displaying the form and automatically updating the display in response to changes to the model classes.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOForm'
  s.screenshots      = ['https://github.com/Kosoku/KSOForm/raw/master/screenshots/iOS-1.png','https://github.com/Kosoku/KSOForm/raw/master/screenshots/iOS-2.png','https://github.com/Kosoku/KSOForm/raw/master/screenshots/iOS-3.png']
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOForm.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.requires_arc = true

  s.source_files = 'KSOForm/**/*.{h,m}'
  s.exclude_files = 'KSOForm/KSOForm-Info.h'
  s.private_header_files = 'KSOForm/Private/*.h'
  
  s.dependency 'Ditko'
  s.dependency 'Agamotto'
  s.dependency 'Quicksilver'
  s.dependency 'KSOTextValidation'
end
