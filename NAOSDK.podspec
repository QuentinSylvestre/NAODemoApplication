#
# Be sure to run `pod lib lint NAOSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NAOSDK'
  s.version          = "4.3.5"
  s.summary          = 'NAOSDK is the Polestar indoor location services SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The following services are available in NAOSDK:

- Location Service
- Geofencing Service
- Beacon Proximity Service
- Analytics Service
- Beacon Maintenance and Reporting Service
                       DESC

  s.homepage         = 'http://docs.nao-cloud.com/'
  s.license          = { :type => 'POLESTAR', :file => 'LICENSE' }
  s.author           = { 'Pole Star' => 'support@polestar.eu' }
  s.source           = { :git => 'https://bitbucket.org/polestarusa/naosdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

# build
  s.libraries = "c++", "z"
  s.frameworks  = "CoreBluetooth", "CoreLocation", "CoreMotion", "SystemConfiguration"
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.h'
  s.vendored_libraries = 'Pod/Classes/libNAOSDK.a'
  # s.public_header_files = 'Pod/Classes/**/*.h'

  # s.resource_bundles = {
  #   'NAOSDK' => ['NAOSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
