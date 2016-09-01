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
* iOS 8.0 or higher
* [CocoaPods](http://cocoapods.org/) package manager:
``` bash
$ [sudo] gem install cocoapods
```

## License
See the LICENSE file for more info.

# Building demo application
To run the provided sample project (NAODemoApplication), clone or download this repo, and run:
```bash
$ cd Example
$ pod install
$ open NAODemoApplication.xcworkspace
```

# Add NAOSDK to your project with CocoaPods
To add NAOSDK to your project, simply add the following line to your Podfile:
```ruby
pod "NAOSDK"
```
Then, [configure your Xcode project](http://docs.nao-cloud.com/dev/Getting_started/NAO_SDK_iOS/#configure-your-xcode-project/).