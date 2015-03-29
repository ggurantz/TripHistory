//
//  LFTripsManager.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFTrip;

/*
 A controller to sit on top of LFActiveTrip and manage the
 serializing of trips as they are created. You only want to create
 one of these, either as a singleton or passed around object, since
 it is using shared data storage
 */

extern NSString *const LFTripsManagerDidBeginNewTripNotification;
extern NSString *const LFTripsManagerDidUpdateTripNotification;
extern NSString *const LFTripsManagerDidCompleteTripNotification;
extern NSString *const LFTripsManagerDidFailAuthorization;

@interface LFTripsManager : NSObject

@property (readonly) NSArray *allTrips;
- (void)removeAllTrips;

@property (nonatomic, readwrite, assign) BOOL loggingEnabled;

- (NSString *)startAddressForTrip:(LFTrip *)trip;
- (NSString *)endAddressForTrip:(LFTrip *)trip;

@end
