//
//  LFTripsManagerTestCase.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LFTripsManager+Protected.h"
#import "LFActiveTripManager.h"
#import "LFActiveTrip.h"

@interface LFTripsManagerTestCase : XCTestCase

@property (nonatomic, readwrite, strong) LFTripsManager *tripsManager;

@end

@implementation LFTripsManagerTestCase

- (void)setUp
{
    [super setUp];
    
    self.tripsManager = [self createTestTripsManager];
}

- (void)tearDown
{
    [self.tripsManager removeAllTrips];
}

- (LFTripsManager *)createTestTripsManager
{
    return [[LFTripsManager alloc] init];
}

- (void)createATrip
{
    LFActiveTripManager *activeTripManager = self.tripsManager.activeTripManager;
    [[activeTripManager delegate] activeTripManager:activeTripManager
                                    didBeginNewTrip:[[LFActiveTrip alloc] init]];
}

- (void)testThatItCreatesATrip
{
    XCTAssertEqual(self.tripsManager.allTrips.count, 0);
    
    self.tripsManager.loggingEnabled = YES;
    [self createATrip];
    
    XCTAssertEqual(self.tripsManager.allTrips.count, 1);
}

- (void)testThatItSerializesObjects
{
    XCTAssertEqual(self.tripsManager.allTrips.count, 0);
    
    [self createATrip];
    
    LFTripsManager *tripsManager = [self createTestTripsManager];
    
    XCTAssertEqual(tripsManager.allTrips.count, 1);
}

- (void)testThatAuthorizationFailureTurnsLoggingOff
{
    self.tripsManager.loggingEnabled = YES;
    LFActiveTripManager *activeTripManager = self.tripsManager.activeTripManager;
    
    [activeTripManager.delegate activeTripManager:activeTripManager didFailAuthorizationWithError:[NSError errorWithDomain:@"blah" code:0 userInfo:nil]];
    
    XCTAssertFalse(self.tripsManager.loggingEnabled);
}

@end
