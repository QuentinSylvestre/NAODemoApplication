//
//  AnalyticsSynchroManager.h
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAOSyncDelegate.h"
#import "AnalyticsSynchroManagerDelegate.h"

@interface AnalyticsSynchroManager : NSObject <NAOSyncDelegate>

- (id)initWithDelegate:(id<AnalyticsSynchroManagerDelegate>)delegate;
- (void)setDelegate:(id<AnalyticsSynchroManagerDelegate>)delegate;

@end
