//
//  NotificationManager.m
//  NAODemoApplication
//
//  Created by Pole Star on 18/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

- (id)init {
    if (self = [super init]) {
        [self setUpNotification];
    }
    return self;
}

- (void)setUpNotification {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS >= 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                                                                                          | UIUserNotificationTypeAlert
                                                                                                                          | UIUserNotificationTypeBadge)
                                                                                                              categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge
                                                                                | UIRemoteNotificationTypeAlert
                                                                                | UIRemoteNotificationTypeSound)];
    }
}

- (void)displayNotificationWithMessage:(NSString *)message {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss.SSS"];
    localNotification.alertBody = [NSString stringWithFormat:@"%@ : %@", [formatter stringFromDate:[NSDate date]], message] ; //[NSString stringWithFormat:@"You've entered site %@", name];
    localNotification.fireDate = [[NSDate alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //localNotification.alertAction = NSLocalizedString(@"Action", nil);
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    });
}

-(void)displayWelcomeToParkingNotificationWithParkingName:(NSString *)parkingName startMapActivityKey:(NSString *)startMapActivityKey{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss.SSS"];
    localNotification.fireDate = [[NSDate alloc] init];
    localNotification.alertBody =  [NSString stringWithFormat:@"%@ : Welcome to %@ \nThis is a smart parking, it can remember your parking slot for you!", [formatter stringFromDate:[NSDate date]], parkingName];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSNumber numberWithInt:1] forKey:startMapActivityKey];
    
    localNotification.userInfo = userInfo;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}

-(void)displayParkingSlotNotificationWithparkingSlot:(NSString *)parkingSlot startMapActivityKey:(NSString *)startMapActivityKey parkingSlotKey:(NSString *)parkingSlotKey{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss.SSS"];
    localNotification.fireDate = [[NSDate alloc] init];
    localNotification.alertBody =  [NSString stringWithFormat:@"%@ : Your parking slot is %@ \nPlease click here to confirm.", [formatter stringFromDate:[NSDate date]], parkingSlot];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue:[NSNumber numberWithInt:1] forKey:startMapActivityKey];
    [userInfo setValue:parkingSlot forKey:parkingSlotKey];
    
    localNotification.userInfo = userInfo;
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    });
}


@end
