//
//  NotificationManager.m
//  NAODemoApplication
//
//  Created by Pole Star on 18/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "NotificationManager.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation NotificationManager

- (id)init {
    if (self = [super init]) {
        [self setUpNotification];
    }
    return self;
}

- (void)setUpNotification {
    
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        // iOS >= 10 Notifications
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNNotificationPresentationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      NSLog(@"request authorization succeeded!");
                                  }
                              }];
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS >= 8 Notifications
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                                                                                              | UIUserNotificationTypeAlert
                                                                                                                              | UIUserNotificationTypeBadge)
                                                                                                                  categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

- (void)displayNotificationWithMessage:(NSString *)message {
    [self displayNotificationWithMessage:message withTimer:[NSNumber numberWithFloat:0.1]];
}

- (void)displayNotificationWithMessage:(NSString *)message withTimer:(NSNumber *)timer {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss.SSS"];
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        //content.title = [NSString localizedUserNotificationStringForKey:@"Elon said:" arguments:nil];
        content.body = [NSString stringWithFormat:@"%@ : %@",
                        [formatter stringFromDate:[NSDate dateWithTimeInterval:[timer floatValue] sinceDate:[[NSDate alloc] init]]],
                        message];
        content.sound = [UNNotificationSound defaultSound];
        
        /// 4. update application icon badge number
        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        // Deliver the notification in five seconds.
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:[timer floatValue] repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[formatter stringFromDate:[NSDate date]]
                                                                              content:content trigger:trigger];
        /// 3. schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"add NotificationRequest succeeded!");
            }
        }];
        
        
    } else {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        
        localNotification.alertBody = [NSString stringWithFormat:@"%@ : %@",
                                       [formatter stringFromDate:[NSDate dateWithTimeInterval:[timer floatValue] sinceDate:[[NSDate alloc] init]]],
                                       message]; //[NSString stringWithFormat:@"You've entered site %@", name];
        localNotification.fireDate = [NSDate dateWithTimeInterval:[timer floatValue] sinceDate:[[NSDate alloc] init]] ;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //localNotification.alertAction = NSLocalizedString(@"Action", nil);
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        });
    }
}


#pragma mark - Implem of NUserNotificationCenterDelegate
//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"%@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd),notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"%@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd),response.notification.request.content.userInfo);
    completionHandler();
}

@end
