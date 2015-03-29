//
//  LFActiveTrip.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

/*
 Effectively a mutable LFTrip, that you can modify the locations of
*/

#import "LFTrip.h"

@interface LFActiveTrip : LFTrip

- (void)updateState:(LFTripState)state;
- (void)addLocations:(NSArray *)locations;

@end
