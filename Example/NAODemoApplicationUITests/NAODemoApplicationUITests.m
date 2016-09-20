//
//  NAODemoApplicationUITests.m
//  NAODemoApplicationUITests
//
//  Created by Pole Star on 13/04/2016.
//  Copyright © 2016 Pole Star. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <NAOSDK/NAOSDK.h>
@interface NAODemoApplicationUITests : XCTestCase<NAOLocationHandleDelegate, NAOSyncDelegate, NAOSensorsDelegate>

@end

@implementation NAODemoApplicationUITests {
    NAOLocationHandle *locationHandle;
    XCTestExpectation *expectation;
}

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSynchro {
    //TODO: insert your app key
    locationHandle = [[NAOLocationHandle alloc] initWithKey:@"rnKk22vZHX5tKuKjQiyBg" delegate:self sensorsDelegate:self];
    NSLog(@"NAODemoApp : %@ : %@ : Version : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NAOServicesConfig getSoftwareVersion]);
    
    [locationHandle synchronizeData:self];
    
    expectation = [self expectationWithDescription:@"Expection for position"];
    
    [self waitForExpectationsWithTimeout:50.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


#pragma mark - NAOLocationHandleDelegate

- (void) didLocationChange:(CLLocation *)location {
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [location description]);
}

- (void) didFailWithErrorCode:(DBNAOERRORCODE)errCode andMessage:(NSString *)message {
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
}

- (void) didLocationStatusChanged:(DBTNAOFIXSTATUS)status {
    NSString* statusString = [self stringFromStatus:status];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), statusString);
}


- (NSString*) stringFromStatus:(DBTNAOFIXSTATUS) status {
    switch (status) {
        case DBTNAOFIXSTATUS_NAO_FIX_UNAVAILABLE:
            return @"FIX_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_FIX_AVAILABLE:
            return @"AVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_TEMPORARY_UNAVAILABLE:
            return @"TEMPORARY_UNAVAILABLE";
            break;
        case DBTNAOFIXSTATUS_NAO_OUT_OF_SERVICE:
            return @"OUT_OF_SERVICE";
            break;
        default:
            return @"UNKNOWN";
            break;
    }
}

- (void) didEnterSite:(NSString *)name {
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
}

- (void) didExitSite:(NSString *)name {
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
}

#pragma mark - NAOSyncDelegate

- (void)  didSynchronizationSuccess {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (expectation != nil) {
        [expectation fulfill];
    }
}

- (void)  didSynchronizationFailure:(DBNAOERRORCODE)errorCode msg:(NSString*) message {
    NSString *errorText = [NSString stringWithFormat:@"errorCode:%ld  message:%@", (long)errorCode, message];
    NSLog(@"NAODemoApp : %@ : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), errorText);
    XCTFail(@"SynchroFailure %@", message);
}

#pragma mark - NAOSensorsDelegate

- (void)requiresBLEOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresWifiOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresLocationOn {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)requiresCompassCalibration {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

//Optional
- (void)didCompassCalibrated {
    NSLog(@"NAODemoApp : %@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}


@end
