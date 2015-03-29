//
//  LFTripsManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripsManager.h"
#import "LFActiveTripManager.h"
#import "NSNotification+LFTrip.h"
#import "NSNotification+NSError.h"

NSString *const LFTripsManagerDidBeginNewTripNotification = @"LFTripsManagerDidBeginNewTripNotification";
NSString *const LFTripsManagerDidUpdateTripNotification = @"LFTripsManagerDidUpdateTripNotification";
NSString *const LFTripsManagerDidCompleteTripNotification = @"LFTripsManagerDidCompleteTripNotification";
NSString *const LFTripsManagerDidFailAuthorization = @"LFTripsManagerDidFailAuthorization";

@interface LFTripsManager () <LFActiveTripManagerDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray *trips;
@property (nonatomic, readwrite, strong) LFActiveTripManager *activeTripManager;
@property (nonatomic, readwrite, strong) NSNotificationCenter *notificationCenter;

@end

@implementation LFTripsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trips = [NSMutableArray array];
        self.notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (NSArray *)allTrips
{
    return self.trips;
}

- (void)removeAllTrips
{
    [self.trips removeAllObjects];
}

- (BOOL)loggingEnabled
{
    return self.activeTripManager != nil;
}

- (void)setLoggingEnabled:(BOOL)loggingEnabled
{
    if (loggingEnabled != self.loggingEnabled)
    {
        if (loggingEnabled)
        {
            self.activeTripManager = [[LFActiveTripManager alloc] initWithDelegate:self];
        }
        else
        {
            self.activeTripManager = nil;
        }
    }
}

#pragma mark - LFActiveTripManagerDelegate

- (void)activeTripManager:(LFActiveTripManager *)tripManager didBeginNewTrip:(LFTrip *)trip
{
    [self.trips insertObject:trip atIndex:0];
    [self.notificationCenter postNotificationName:LFTripsManagerDidBeginNewTripNotification
                                           object:self
                                             trip:trip];
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didUpdateTrip:(LFTrip *)trip
{
    [self.notificationCenter postNotificationName:LFTripsManagerDidUpdateTripNotification
                                           object:self
                                             trip:trip];
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didCompleteTrip:(LFTrip *)trip
{
    [self.notificationCenter postNotificationName:LFTripsManagerDidCompleteTripNotification
                                           object:self
                                             trip:trip];
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didFailAuthorizationWithError:(NSError *)error
{
    self.loggingEnabled = NO;
    [self.notificationCenter postNotificationName:LFTripsManagerDidFailAuthorization
                                           object:self
                                            error:error];
}

@end
