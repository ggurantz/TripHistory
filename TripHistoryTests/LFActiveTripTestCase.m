//
//  LFTripTestCase.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LFActiveTrip.h"
#import <CoreLocation/CoreLocation.h>

@interface LFActiveTripTestCase : XCTestCase

@end

@implementation LFActiveTripTestCase

- (NSArray *)randomLocations
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:10.0 longitude:10.0];
    
    return @[location];
}

- (void)testThatItAssertsIfTryingToAddToACompletedTrip {
    LFActiveTrip *activeTrip = [[LFActiveTrip alloc] init];
    
    [activeTrip updateState:LFTripStateActive];
    
    XCTAssertNoThrow([activeTrip addLocations:[self randomLocations]]);
    
    [activeTrip updateState:LFTripStateCompleted];
    
    XCTAssertThrows([activeTrip addLocations:[self randomLocations]]);
}

@end
