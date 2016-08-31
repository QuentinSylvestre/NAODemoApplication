//
//  GeofencingSynchroManager.m
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import "GeofencingSynchroManager.h"

@implementation GeofencingSynchroManager {
    @private
    id<GeofencingSynchroManagerDelegate> _geoSynchroDelegate;
}

-(id)initWithDelegate:(id<GeofencingSynchroManagerDelegate>)delegate {
    if (self = [self init]) {
        [self setDelegate:delegate];
    }
    return self;
}

-(void)setDelegate:(id<GeofencingSynchroManagerDelegate>)delegate {
    _geoSynchroDelegate = delegate;
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    NSLog(@"NAODemoApp : GeofencingSynchroManager : didSynchronizationSuccess");
    [_geoSynchroDelegate didSynchronizationGeofencingSuccess];
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSLog(@"NAODemoApp : GeofencingSynchroManager : didSynchronizationFailure : %@", message);
    [_geoSynchroDelegate didSynchronizationGeofencingFailure:message];
}


@end
