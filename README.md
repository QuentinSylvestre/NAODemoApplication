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

### Configure your Xcode project
Since iOS 9 and [App Transport Security](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/), you need to whitelist the Pole Star urls (which use AWS servers).

* In Xcode right-click the **Info.plist** file and choose "Open As > Source Code".
* Just before the last ```</dict>``` line, copy and paste the following lines in it:

```xml
<key>NSAppTransportSecurity</key>
<dict>
<key>NSExceptionDomains</key>
<dict>
<key>amazonaws.com</key>
<dict>
<key>NSThirdPartyExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
<false/>
<key>NSIncludesSubdomains</key>
<true/>
</dict>
<key>amazonaws.com.cn</key>
<dict>
<key>NSThirdPartyExceptionMinimumTLSVersion</key>
<string>TLSv1.0</string>
<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
<false/>
<key>NSIncludesSubdomains</key>
<true/>
</dict>
</dict>
</dict>
```

Copy and paste the following lines to use the NAO SDK services in the relevant mode.  
**Note**: the message will be displayed to the end user, so you should change it.

- Foreground mode:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>NAO SDK will have access to your location information when using the application</string>
```

- Background mode:
```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>NAO SDK will have access permanently to your location information</string>

<key>UIBackgroundModes</key>
<array>
<string>location</string>
</array>
```
**Warning**: always declare ```UIBackgroundModes``` and ```NSLocationAlwaysUsageDescription``` at the same time or it might cause your application to crash.

