//
//  THActiveTripManager.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFTrip;
@protocol LFActiveTripManagerDelegate;

@interface LFActiveTripManager : NSObject

- (instancetype)initWithDelegate:(id<LFActiveTripManagerDelegate>)delegate;

// May be nil if no active trip
@property (nonatomic, readonly, strong) LFTrip *trip;

@end

@protocol LFActiveTripManagerDelegate <NSObject>

- (void)activeTripManager:(LFActiveTripManager *)tripManager didBeginNewTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didUpdateTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didCompleteTrip:(LFTrip *)trip;
- (void)activeTripManager:(LFActiveTripManager *)tripManager didFailAuthorizationWithError:(NSError *)error;

@end