//
//  GeofencingSynchroManager.h
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAOSyncDelegate.h"
#import "GeofencingSynchroManagerDelegate.h"

@interface GeofencingSynchroManager : NSObject <NAOSyncDelegate>

- (id)initWithDelegate:(id<GeofencingSynchroManagerDelegate>)delegate;
- (void)setDelegate:(id<GeofencingSynchroManagerDelegate>)delegate;

@end
