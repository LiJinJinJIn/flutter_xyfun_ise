#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_xfyun_ise.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_xfyun_ise'
  s.version          = '0.0.1'
  s.summary          = 'xfyun ise'
  s.description      = <<-DESC
xfyun ise
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'Classes/ise/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.vendored_frameworks = 'Frameworks/iflyMSC.framework'
  # s.frameworks = 'libz.tbd', 'AVFoundation.framework', 'SystemConfiguration.framework', 'Foundation.framework', 'CoreTelephony.framework', 'AudioToolbox.framework', 'UIKit.framework', 'CoreLocation.framework', 'Contacts.framework', 'AddressBook.framework', 'QuartzCore.framework', 'CoreGraphics.framework', 'libc++.tbd'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
