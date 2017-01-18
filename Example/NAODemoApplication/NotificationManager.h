//
//  NotificationManager.h
//  NAODemoApplication
//
//  Created by Pole Star on 18/03/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationManager : NSObject <UNUserNotificationCenterDelegate>

- (id)init;
- (void)displayNotificationWithMessage:(NSString *)message;
- (void)displayNotificationWithMessage:(NSString *)message withTimer:(NSNumber *)timer;

@end
