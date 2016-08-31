# NAOSDK
[![Version](https://img.shields.io/cocoapods/v/NAOSDK.svg?style=flat)](http://cocoapods.org/pods/NAOSDK)
[![License](https://img.shields.io/cocoapods/l/NAOSDK.svg?style=flat)](http://cocoapods.org/pods/NAOSDK)
[![Platform](https://img.shields.io/cocoapods/p/NAOSDK.svg?style=flat)](http://cocoapods.org/pods/NAOSDK)

The following services are available in NAOSDK:

- Location Service
- Geofencing Service
- Beacon Proximity Service
- Analytics Service
- Beacon Maintenance and Reporting Service

## Requirements
* Xcode 7 or higher
* CocoaPods
* iOS 8.0 or higher

## License
See the LICENSE file for more info.

## Building demo application
You should have the [CocoaPods](http://cocoapods.org/) package manager installed on your system. Install CocoaPods if not already available:
``` bash
$ [sudo] gem install cocoapods
```

To run the provided example project, clone or download this repo, and run:
```bash
$ cd Example
$ pod install
$ open NAODemoApplication.xcworkspace
```

## CocoaPods
To add NAOSDK to your project, simply add the following line to your Podfile:
```ruby
pod "NAOSDK"
```