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


### Service Selection
Whatever the services you are using, there are two mandatory delegates that your app must implement, since they're used by all the services.

* **Data Synchronisation Delegate** (```NAOSyncDelegate```):    
Gives you the result of the data synchronisation requested by the service handle.   
The synchronisation ensures the configuration data of the selected service matches the one on NAO Cloud. 

* **Sensor Activation Delegate** (```NAOSensorsDelegate```):    
Used to notify the user that some sensors are required by the running service, and thus should be manually activated.


Several optional services are available, each service has its Handle class and its Delegate Protocol:

* **Location Service** (```NAOLocationHandle``` , ```NAOLocationHandleDelegate```):   
Provides the location of the user in a WGS84 format. It enables you to display the user position on a map.

* **Geographical Geofencing Service** (```NAOGeofencingHandle``` , ```NAOGeofencingHandleDelegate```):   
Provides geographical events when the user is entering a given zone.  
This service is mainly use to engage the user with notifications or for a geographical contextualization of the digital content of your application.

* **Beacon Proximity Service** (```NAOBeaconHandle``` , ```NAOBeaconHandleDelegate```):   
Provides information about the beacons around the user, this is useful to contextualize notifications or the digital content of your application when the accuracy of this contextualization is not critical.

* **Analytics Service** (```NAOAnalyticsHandle``` , ```NAOAnalyticsHandleDelegate```):   
This service provides some statistics on the number of user that enter a zone.   
These analytics can be seen on the NAO Analytics Plaform, but can also be exported to your back-office for custom data analysis.


* **Beacon Reporting Status Service** (```NAOBeaconReportingHandle``` , ```NAOBeaconReportingManagerDelegate```):   
This service enables to monitor your beacon infrastructure automatically.   
The beacon information like status, health, or estimated battery life are collected by the SDK embedded inside the application.   
This information is visible on the Beacon section of NAO Cloud.


### Sample code: Location Service

The integration principle is the same accross all NAO services, so only the integration of the Location Service is detailed hereafter.  
Please refer to the [API Reference Guide](../../dev/api/iOS/html/index.html) for details about other services.

#### Initialize Location Service

* Import the following header into your source file:   
```objective_c
#import <NAOSDK/NAOSDK.h>
```

* Get an API Key on NAO Cloud (that key is created when you create a site on NAO Cloud).  
If a site is used in several applications, you can also create a new API key for the same site in NAO Cloud Developer section.

* implement the ```NAOSyncDelegate```, ```NAOLocationHandleDelegate```, ```NAOSensorsDelegate``` protocols on any object of your choosing (e.g. a ```UIViewController```), 
You will then be able to receive the NAO engine callbacks.
* You may also declare a ```NAOLocationHandle``` member (or property) as you will need this to interact with the Location service.
```objective_c
@interface MyCustomViewController : UIViewController <NAOSyncDelegate, NAOLocationHandleDelegate, NAOSensorsDelegate> {
    NAOLocationHandle * mLocationHandle;
}
@end
```

* In the code, initialize your ```NAOLocationHandle``` object, configure it with your API key and your delegates:
```objective_c
mLocationHandle = [[NAOLocationHandle alloc] initWithKey:@"YOUR_API_KEY" 
                                             delegate:/* your (id<NAOLocationHandleDelegate>) */
                                             sensorsDelegate:/* your (id<NAOSensorsDelegate>) */];
```

* You should now call synchronizeData to retrieve the positioning database (PDB) available on NAO Cloud:
```objective_c
[mLocationHandle synchronizeData:/* your (id<NAOSyncDelegate>) */];
```

* Implement the synchronization callbacks, the location will be ready to start when the sync succeeds.
```objective_c
- (void)didSynchronizationSuccess {
    // sync OK !
    // you may now start the location service.
    [mLocationHandle start];
}

- (void)didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    // synchronization failed, check error code and message !
}
```

* You need to stop your NAOLocationHandle when you don't need it anymore (it will be stopped if there's no delegate).
```objective_c
[mLocationHandle stop];
```

#### Request sensor activation
* The user may not have its phone's sensors activated.  
In that case, the engine will trigger some callbacks that you can use to ask the user for sensor activation:
```objective_c
- (void) requiresWifiOn {
   // warn the user (ie. with an UIAlertController)
}
- (void) requiresBLEOn {
    // warn the user (ie. with an UIAlertController)
}
- (void) requiresLocationOn {
    // warn the user (ie. with an UIAlertController)
}
- (void) requiresCompassCalibration {
    // warn the user (ie. with an UIAlertController)
}
```


#### Get The User Location

* In standard mode, a user location will be sent every second by this method.   
The location given by the NAOLocationHandle is in a WGS84 format (like GPS) and it is encapsulated into a standard CLLocation object:
```objective_c
- (void) didLocationChange:(CLLocation *) location {
    // a new location has been received !
    // you can display the user location to your map here
}
```

* The following method will let you know when the NAOLocationHandle status changes
fFor more information about the status please refer to the [API Reference Guide](../../dev/api/iOS/html/index.html)).
```objective_c
- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
}
```

* If an error occurs, that callback is triggered:
```objective_c
- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSLog(@"Location Error: %@", message);
}
```

### Emulate User Position

If you do not yet have a key available on NAO Cloud, you may test your integration of the NAO SDK with the ```emulator``` API Key.  
This key can be used only for **Location Service** and **Geofencing Service**.   
For the location service, it will emulate a user position. Just create an instance of ```NAOLocationHandle``` as usual:
```objective_c
mLocationHandle = [[NAOLocationHandle alloc] initWithKey:@"emulator" 
                                                delegate:/* your (id<NAOLocationHandleDelegate>) */
                                         sensorsDelegate:/* your (id<NAOSensorsDelegate>) */];
```

**Warning**: This API Key **does not** use the sensors: the integration of the sensor activation delegate can't be tested with it.

You will also need to add a position emulation file (```nao.kml```). Drag and drop the nao.kml in your Xcode project navigator, check the box "Copy items if needed" and verify the presence of the file added in Build Phases -> Copy Bundle Resources.   
You can download this file from NAO Cloud, from your site's dashboard (under Developer > Resources tab)

For the **Geofencing Service** you need to add the geofencing emulation file (```alerts_emulator.json```) the same away as above for the nao.kml. and to create an instance of ```NAOGeofencingHandle``` as usual:
```objective_c
NAOGeofencingHandle* geofencingHandle = [[NAOGeofencingHandle alloc] initWithKey:@"emulator" 
                                                                  delegate:/* your (id<NAOGeofencingHandleDelegate>) */
                                                           sensorsDelegate:/* your (id<NAOSensorsDelegate>) */];
```

### Working offline: embed data files

You might wish to avoid the online synchronization with NAO Cloud, in order have a fully-offline location service, or if you want to embed the data inside the application before the first data synchronisation.  
If so, you need to add a PDB file (```site_id.jscx```). Drag and drop the PDB file in your Xcode project navigator, check the box "Copy items if needed" and verify the presence of the file added in Build Phases -> Copy Bundle Resources.  
You can download this file from NAO Cloud, from your site's dashboard (under Developer > Resources tab)

#### Use Your Private Server

Optionally, you can use your private server to host the configuration files (PDB and app.json).  
To do that, you just need to configure the class ```NAOServicesConfig```.   
This class will be used by all the NAO Services:
```objective_c
[NAOServicesConfig setRootUrl("YOUR_SERVER_URL")];
```