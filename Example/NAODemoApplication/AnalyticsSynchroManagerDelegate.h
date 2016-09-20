//
//  AnalyticsSynchroManagerDelegate.h
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnalyticsSynchroManagerDelegate <NSObject>

- (void)  didSynchronizationAnalyticsSuccess;
- (void)  didSynchronizationAnalyticsFailure:(NSString* )message;

@end
