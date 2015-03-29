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
#import "LFTrip.h"

NSString *const LFTripsManagerDidBeginNewTripNotification = @"LFTripsManagerDidBeginNewTripNotification";
NSString *const LFTripsManagerDidUpdateTripNotification = @"LFTripsManagerDidUpdateTripNotification";
NSString *const LFTripsManagerDidCompleteTripNotification = @"LFTripsManagerDidCompleteTripNotification";
NSString *const LFTripsManagerDidFailAuthorization = @"LFTripsManagerDidFailAuthorization";

@interface LFTripsManager () <LFActiveTripManagerDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray *trips;
@property (nonatomic, readwrite, strong) LFActiveTripManager *activeTripManager;
@property (nonatomic, readwrite, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, readwrite, strong) CLGeocoder *geocoder;

@end

@implementation LFTripsManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trips = [NSMutableArray array];
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.geocoder = [[CLGeocoder alloc] init];
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
            [self.activeTripManager startUpdatingLocation];
        }
        else
        {
            [self.activeTripManager stopUpdatingLocation];
            self.activeTripManager = nil;
        }
    }
}

#pragma mark - Geocoding

- (void)reverseGeocoderLocation:(CLLocation *)location
                        success:(void (^)(NSString *address))completion
{
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (error == nil && placemarks.count > 0)
                            {
                                completion([placemarks[0] thoroughfare]);
                            }
                        }];
}

- (NSString *)startAddressForTrip:(LFTrip *)trip
{
    if (trip.startLocationAddress.length == 0)
    {
        __block LFTripsManager *blockSelf = self;
        [self reverseGeocoderLocation:trip.startLocation
                              success:^(NSString *address) {
                                  trip.startLocationAddress = address;
                                  [blockSelf postUpdateNotificationForTrip:trip];
                              }];
    }
    
    return trip.startLocationAddress;
}

- (NSString *)endAddressForTrip:(LFTrip *)trip
{
    if (trip.endLocationAddress.length == 0)
    {
        __block LFTripsManager *blockSelf = self;
        [self reverseGeocoderLocation:trip.endLocation
                              success:^(NSString *address) {
                                  trip.endLocationAddress = address;
                                  [blockSelf postUpdateNotificationForTrip:trip];
                              }];
    }
    
    return trip.endLocationAddress;
}

- (void)postUpdateNotificationForTrip:(LFTrip *)trip
{
    [self.notificationCenter postNotificationName:LFTripsManagerDidUpdateTripNotification
                                           object:self
                                             trip:trip];
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
    [self postUpdateNotificationForTrip:trip];
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
