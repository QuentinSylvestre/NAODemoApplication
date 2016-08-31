//
//  NaoContext.h
//  NaoSDK
//
//  Created by Pole Star on 02/02/2016.
//  Copyright © 2016 POLE STAR SA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTPOWERMODE.h"
#import "NAOSyncDelegate.h"

@class DBINAOServiceManager;
@class NAOSensorsManager;
@class NaoSynchroBroker;

/** For Polestar internal use */
@interface NaoContext : NSObject

@property (strong) DBINAOServiceManager *serviceManager;
@property (strong) NAOSensorsManager *sensorsManager;
@property (strong) NaoSynchroBroker *synchroBroker;
@property (strong, nonatomic) NSString *mRootURL;

- (id)init;

- (NSString *)getRootURL;
- (NSString *)getSoftwareVersion;
- (void)setRootURL:(NSString *)rootURL;
- (DBTPOWERMODE)getPowerMode;
- (void)synchronizeData:(id<NAOSyncDelegate>)delegate apiKey:(NSString *)apiKey;
- (void)writeToLog:(NSString *)txt;
- (void)uploadNAOLogInfo;

- (NSArray *)regionsOfAllActiveAlerts;

@end
