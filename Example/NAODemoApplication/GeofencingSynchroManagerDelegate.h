//
//  GeofencingSynchroManagerDelegate.h
//  NAODemoApplication
//
//  Created by Pole Star on 21/01/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GeofencingSynchroManagerDelegate <NSObject>

- (void)  didSynchronizationGeofencingSuccess;
- (void)  didSynchronizationGeofencingFailure:(NSString* )message;

@end
