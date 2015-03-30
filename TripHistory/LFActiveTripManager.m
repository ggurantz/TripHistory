//
//  THActiveTripManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFActiveTripManager.h"
#import "LFLocationManager.h"
#import "LFActiveTrip.h"
#import <CoreMotion/CoreMotion.h>

CLLocationSpeed const kLFActiveTripManagerTripStartSpeed = 4.4704f; // 10 mph
CLLocationSpeed const kLFActiveTripManagerMinimumActivitySpeed = 0.44704f; // 1 mph
NSTimeInterval const kLFActiveTripManagerTripEndIdleTimeInterval = 3.0f; // 1 minute

@interface LFActiveTripManager ()

@property (nonatomic, readwrite, weak) id<LFActiveTripManagerDelegate> delegate;
@property (nonatomic, readwrite, strong) LFLocationManager *locationManager;
@property (nonatomic, readwrite, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, readwrite, strong) LFActiveTrip *activeTrip;
@property (nonatomic, readwrite, strong) NSOperationQueue *activityManagerOperationQueue;

@end

@implementation LFActiveTripManager

- (void)dealloc
{
    [_activityManager stopActivityUpdates];
    [_activityManagerOperationQueue cancelAllOperations];
}

- (instancetype)initWithDelegate:(id<LFActiveTripManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.activityManager = [[CMMotionActivityManager alloc] init];
        
    }
    return self;
}

- (void)startUpdatingLocation
{
    self.locationManager = [[LFLocationManager alloc] initWithDelegate:self];
    
    if ([CMMotionActivityManager isActivityAvailable])
    {
        self.activityManagerOperationQueue = [[NSOperationQueue alloc] init];
        self.activityManager = [[CMMotionActivityManager alloc] init];
        
        __block LFActiveTripManager *blockSelf = self;
        [self.activityManager startActivityUpdatesToQueue:self.activityManagerOperationQueue
                                              withHandler:^(CMMotionActivity *activity) {
                                                  LFTripActivityType type = LFTripActivityTypeDriving;
                                                  
                                                  if (activity.cycling)
                                                  {
                                                      type = LFTripActivityTypeCycling;
                                                  }
                                                  else if (activity.running)
                                                  {
                                                      type = LFTripActivityTypeRunning;
                                                  }
                                                  
                                                  LFActiveTrip *activeTrip = blockSelf.activeTrip;
                                                  if (activeTrip != nil &&
                                                      activeTrip.activityType != type)
                                                  {
                                                      activeTrip.activityType = type;
                                                      [blockSelf notifyActiveTripUpdate];
                                                  }
                                              }];
    }
}

- (void)stopUpdatingLocation
{
    self.locationManager = nil;
    [self.activityManager stopActivityUpdates];
    self.activityManager = nil;
    
    [self.activityManagerOperationQueue cancelAllOperations];
    self.activityManagerOperationQueue = nil;
    
    
    [self markActiveTripAsCompleted];
}

- (LFTrip *)trip
{
    return self.activeTrip;
}

- (void)createActiveTripIfNecessaryWithLocation:(CLLocation *)location
{
    if (location.speed >= kLFActiveTripManagerTripStartSpeed)
    {
        self.activeTrip = [[LFActiveTrip alloc] initWithLocations:@[location]];
        [self.delegate activeTripManager:self didBeginNewTrip:self.activeTrip];
    }
}

- (void)markActiveTripAsCompleted
{
    if (self.activeTrip != nil)
    {
        [self.activeTrip updateState:LFTripStateCompleted];
        [self.delegate activeTripManager:self didCompleteTrip:self.activeTrip];
        self.activeTrip = nil;
    }
}

- (void)notifyActiveTripUpdate
{
    NSParameterAssert(self.activeTrip);
    [self.delegate activeTripManager:self didUpdateTrip:self.activeTrip];
}

#pragma mark - LFLocationManagerDelegate

- (void)locationManager:(LFLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        
        if (self.activeTrip == nil)
        {
            [self createActiveTripIfNecessaryWithLocation:location];
        }
        else
        {
            NSTimeInterval timeIntervalSinceLastLocation = [location.timestamp timeIntervalSinceDate:[(CLLocation *)self.activeTrip.locations.lastObject timestamp]];
            
            if (timeIntervalSinceLastLocation >= kLFActiveTripManagerTripEndIdleTimeInterval)
            {
                [self markActiveTripAsCompleted];
                [self createActiveTripIfNecessaryWithLocation:location];
            }
            else if (location.speed > kLFActiveTripManagerMinimumActivitySpeed)
            {
                [self.activeTrip addLocations:@[location]];
                [self notifyActiveTripUpdate];
            }
        }
    }
}

- (void)locationManager:(LFLocationManager *)locationManager didFailAuthorizationWithError:(NSError *)error
{
    [self.delegate activeTripManager:self didFailAuthorizationWithError:error];
}

@end
