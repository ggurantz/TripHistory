//
//  THTrip.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFTimeInterval;

typedef NS_ENUM(NSInteger, LFTripState) {
    LFTripStateActive,
    LFTripStateCompleted
};

@interface LFTrip : NSObject

- (instancetype)init;
- (instancetype)initWithLocations:(NSArray *)locations;

@property (nonatomic, readonly, strong) NSArray *locations;
@property (readonly) LFTripState state;

- (LFTimeInterval *)timeInterval;

@end
