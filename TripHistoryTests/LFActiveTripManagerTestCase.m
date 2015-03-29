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
#import "LFTrip.h"

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

- (void)addLocations:(NSArray *)locations
{
    [self.tripManager locationManager:nil didUpdateLocations:locations];
}

- (CLLocation *)locationWithSpeed:(CLLocationSpeed)speed timeStamp:(NSDate *)timeStamp
{
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(10.0, 10.0)
                                         altitude:10.0
                               horizontalAccuracy:10.0
                                 verticalAccuracy:10.0
                                           course:10.0
                                            speed:speed
                                        timestamp:timeStamp];
}

- (void)assertNoTripsCreated
{
    XCTAssertNil(self.tripManager.trip);
    XCTAssertEqual(self.trips.count, 0);
}

- (void)assertTrip:(LFTrip *)trip isCreatedWithLocations:(NSArray *)locations
{
    XCTAssertNotNil(trip);
    XCTAssertTrue([trip.locations isEqualToArray:locations]);
}

- (void)assertTripIsCreatedWithLocations:(NSArray *)locations
{
    [self assertTrip:self.tripManager.trip isCreatedWithLocations:locations];
    XCTAssertTrue([@[self.tripManager.trip] isEqualToArray:self.trips]);
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

- (void)testThatNoTripExistsWithNoLocationUpdates
{
    [self assertNoTripsCreated];
}

- (void)testThatNoTripGetsCreatedWithLowSpeed
{
    NSArray *locations = @[[self locationWithSpeed:kLFActiveTripManagerTripStartSpeed/2.0
                                       timeStamp:[NSDate date]]];
    [self addLocations:locations];
    [self assertNoTripsCreated];
}

- (void)testThatATripGetsCreatedWithEnoughSpeed
{
    NSArray *locations = @[[self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                       timeStamp:[NSDate date]]];
    [self addLocations:locations];
    [self assertTripIsCreatedWithLocations:locations];
}

- (void)testThatAnUpdateWithLowSpeedDoesNotCreateANewTrip
{
    NSArray *locations = @[
                           [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                         timeStamp:[NSDate date]],
                           [self locationWithSpeed:kLFActiveTripManagerMinimumActivitySpeed
                                         timeStamp:[NSDate date]]
                           ];
    [self addLocations:@[locations[0]]];
    [self addLocations:@[locations[1]]];
    
    [self assertTripIsCreatedWithLocations:@[locations[0]]];
}

- (void)testThatAnUpdateWithHighSpeedDoesNotCreateANewTrip
{
    NSArray *locations = @[
                           [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                         timeStamp:[NSDate date]],
                           [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                         timeStamp:[NSDate date]]
                           ];
    [self addLocations:@[locations[0]]];
    [self addLocations:@[locations[1]]];
    
    XCTAssertEqual(self.updates, 1);
    XCTAssertEqual(self.completions, 0);
    XCTAssertEqual(self.tripManager.trip.state, LFTripStateActive);
    [self assertTripIsCreatedWithLocations:locations];
}

- (void)testThatATripCompletesAfterAMinuteOfInactivity
{
    CLLocation *startLocation = [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                              timeStamp:[NSDate date]];
    CLLocation *endLocation = [self locationWithSpeed:kLFActiveTripManagerMinimumActivitySpeed
                                            timeStamp:[startLocation.timestamp dateByAddingTimeInterval:kLFActiveTripManagerTripEndIdleTimeInterval]];
    
    
    NSArray *locations = @[startLocation, endLocation];
    [self addLocations:locations];
    
    XCTAssertEqual(self.completions, 1);
    XCTAssertEqual([self.trips[0] state], LFTripStateCompleted);
    [self assertTrip:self.trips[0] isCreatedWithLocations:@[startLocation]];
}

- (void)testThatATripIsCreatedAfterAnotherCompletes
{
    CLLocation *startLocation = [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                              timeStamp:[NSDate date]];
    CLLocation *endLocation = [self locationWithSpeed:kLFActiveTripManagerTripStartSpeed
                                            timeStamp:[startLocation.timestamp dateByAddingTimeInterval:kLFActiveTripManagerTripEndIdleTimeInterval]];
    
    
    NSArray *locations = @[startLocation, endLocation];
    [self addLocations:locations];
    
    XCTAssertEqual(self.completions, 1);
    XCTAssertEqual(self.trips.count, 2);
    
    [self assertTrip:self.trips[0] isCreatedWithLocations:@[startLocation]];
    [self assertTrip:self.trips[1] isCreatedWithLocations:@[endLocation]];
    
    XCTAssertEqual([self.trips[0] state], LFTripStateCompleted);
    XCTAssertEqual(self.trips[1], self.tripManager.trip);
    XCTAssertEqual([self.trips[1] state], LFTripStateActive);
}

// Test batch update messages resolving?

@end