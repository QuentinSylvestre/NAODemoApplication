//
//  AppDelegate.m
//  NAODemoApplication
//
//  Created by Pole Star on 26/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import "AppDelegate.h"
#import "SmartPark.h"
#import "MapViewController.h"

#import "NaoContext.h"
#import "NAOServicesConfig.h"

#import <AudioToolbox/AudioServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //NSLog(@"NaoDemoApplication : AppDelegate : didFinishLaunchingWithOptions : launchOption %@", [launchOptions description]);
      
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        NSLog(@"NaoDemoApplication : AppDelegate : restart by iBeacon");
        NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:SMART_PARK_MODE];
        if (key != nil && [key isEqualToString:SMART_PARK_ON]) {
            NSLog(@"NaoDemoApplication : AppDelegate : restart SmartPark");
            SmartPark *smartPark = [[SmartPark alloc] init];
            [smartPark startLocation];
        }
    }
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        NSLog(@"app recieved notification from local%@",notification);
        [self application:application didReceiveLocalNotification:notification];
    }else{
        NSLog(@"app did not recieve notification");
        application.applicationIconBadgeNumber = 0;
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"LocalNotification state=%ld", (long)application.applicationState);
    
    if ([application applicationState] != UIApplicationStateActive) { //Don't execute this if app is in foreground
        if ([notification.userInfo objectForKey:START_MAP_ACTIVITY_KEY]) {
            NSLog(@"NAODemoApp : didReceiveLocalNotification : startMapActivity");
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MapViewController *mapView = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            
            if ([notification.userInfo objectForKey:PARKING_SLOT_KEY]) {
                NSString *parkingSlot = [notification.userInfo objectForKey:PARKING_SLOT_KEY];
                NSLog(@"NAODemoApp : didReceiveLocalNotification : startMapActivity : parkingSlot=%@", parkingSlot);
                
                mapView.parkingSlot = parkingSlot;
            }
            
            [(UINavigationController *)self.window.rootViewController pushViewController:mapView animated:YES];
        }
    } else { //App is on foreground, the notification will not be displayed so do here foreground code
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

@end
