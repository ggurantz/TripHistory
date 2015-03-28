//
//  LFActiveTripManagerTestCase.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "LFActiveTripManager.h"
#import <MKUnits/MKUnits.h>

@interface LFActiveTripManagerTestCase : XCTestCase<LFActiveTripManagerDelegate>

@property (nonatomic, readwrite, strong) LFActiveTripManager *tripManager;
@property (nonatomic, readwrite, strong) NSMutableArray *trips;
@property (nonatomic, readwrite, assign) NSInteger updates;
@property (nonatomic, readwrite, assign) NSInteger completions;
@property (nonatomic, readwrite, strong) NSError *authorizationError;

@end

@implementation LFActiveTripManagerTestCase

- (void)setUp
{
    [super setUp];
    
    self.tripManager = [[LFActiveTripManager alloc] initWithDelegate:self];
    
    self.trips = [NSMutableArray array];
    self.updates = 0;
    self.completions = 0;
    self.authorizationError = nil;
}

- (CLLocation *)locationWithMPH:(CLLocationSpeed)mph timeStamp:(NSDate *)timeStamp
{
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(10.0, 10.0)
                                         altitude:10.0
                               horizontalAccuracy:10.0
                                 verticalAccuracy:10.0
                                           course:10.0
                                            speed:mph
                                        timestamp:timeStamp];
}

#pragma mark - LFActiveTripManagerDelegate

- (void)activeTripManager:(LFActiveTripManager *)tripManager didBeginNewTrip:(LFTrip *)trip
{
    [self.trips addObject:trip];
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didUpdateTrip:(LFTrip *)trip
{
    self.updates++;
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didCompleteTrip:(LFTrip *)trip
{
    self.completions++;
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didFailAuthorizationWithError:(NSError *)error
{
    self.authorizationError = error;
}

#pragma mark - Tests

- (void)testThatATripGetsCreated
{
    CLLocation *location = [self locationWithMPH:10.0 timeStamp:[NSDate date]];

}

// Test that with no trip and then a 10 mph a trip gets started
// Test that with no trip and 5 mph, no trip is started
// Test that with a trip, and then a new piece of 10 mph speed, an update is sent, and no new trip is created
// Test that with a trip, and a minute of no activity, the trip ends
// Test that with a trip, and some mild activity < 10mph, the trip continues

// Questions: minimal movement? Does CLLocationManager continually update us?? Or does it wait? Do I need to
// wait for a minute of no responses from CLLocationManager? No!

// Test batch update messages resolving?

@end