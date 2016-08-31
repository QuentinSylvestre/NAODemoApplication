//
//  AnalyticsSynchroManager.m
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "AnalyticsSynchroManager.h"

@implementation AnalyticsSynchroManager {
@private
    id<AnalyticsSynchroManagerDelegate> _analyticsSynchroDelegate;
}

-(id)initWithDelegate:(id<AnalyticsSynchroManagerDelegate>)delegate {
    if (self = [self init]) {
        [self setDelegate:delegate];
    }
    return self;
}

-(void)setDelegate:(id<AnalyticsSynchroManagerDelegate>)delegate {
    _analyticsSynchroDelegate = delegate;
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    NSLog(@"NAODemoApp : AnalyticsSynchroManager : didSynchronizationSuccess");
    [_analyticsSynchroDelegate didSynchronizationAnalyticsSuccess];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSLog(@"NAODemoApp : AnalyticsSynchroManager : didSynchronizationFailure : %@", message);
    [_analyticsSynchroDelegate didSynchronizationAnalyticsFailure:message];
}


@end
