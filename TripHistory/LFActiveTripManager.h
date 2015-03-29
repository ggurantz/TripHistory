//
//  THActiveTripManager.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LFLocationManager.h"

@class LFTrip;
@protocol LFActiveTripManagerDelegate;

extern CLLocationSpeed const kLFActiveTripManagerTripStartSpeed;
extern CLLocationSpeed const kLFActiveTripManagerMinimumActivitySpeed;
extern NSTimeInterval const kLFActiveTripManagerTripEndIdleTimeInterval;

@interface LFActiveTripManager : NSObject<LFLocationManagerDelegate>

- (instancetype)initWithDelegate:(id<LFActiveTripManagerDelegate>)delegate;
@property (nonatomic, readonly, weak) id<LFActiveTripManagerDelegate> delegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

/*
 The current trip being recorded. Will return nil if there is no active trip.
 */
@property (readonly) LFTrip *trip;

@end

@protocol LFActiveTripManagerDelegate <NSObject>

- (void)activeTripManager:(LFActiveTripManager *)tripManager didBeginNewTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didUpdateTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didCompleteTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didFailAuthorizationWithError:(NSError *)error;

@end