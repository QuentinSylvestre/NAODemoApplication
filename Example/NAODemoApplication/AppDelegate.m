//
//  AppDelegate.m
//  NAODemoApplication
//
//  Created by Pole Star on 26/11/2015.
//  Copyright © 2015 Pole Star. All rights reserved.
//

#import "AppDelegate.h"
#import "WakeService.h"

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
        NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:WAKE_SERVICE_MODE];
        if (key != nil && [key isEqualToString:WAKE_SERVICE_ON]) {
            NSLog(@"NaoDemoApplication : AppDelegate : restart WakeLock");
            WakeService *wakeService = [WakeService sharedInstance];;
            [wakeService startLocation];
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

    } else { //App is on foreground, the notification will not be displayed so do here foreground code
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"LocalNotification state=%ld", (long)application.applicationState);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"LocalNotification state=%ld", (long)application.applicationState);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

@end
