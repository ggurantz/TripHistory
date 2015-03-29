//
//  THTrip.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTrip.h"
#import "LFTimeInterval.h"
#import <CoreLocation/CoreLocation.h>

@interface LFTrip ()

@property (nonatomic, readwrite, strong) NSArray *locations;

@end

@implementation LFTrip

- (instancetype)initWithLocations:(NSArray *)locations
{
    NSAssert(locations.count > 0, @"A trip must have at least one location");
    
    self = [self init];
    if (self)
    {
        self.locations = locations;
    }
    return self;
}

- (LFTripState)state
{
    return LFTripStateCompleted;
}

- (LFTimeInterval *)timeInterval
{
    NSAssert(self.locations.count > 0, @"A trip must have at least one location");
    CLLocation *firstLocation = [self.locations objectAtIndex:0];
    CLLocation *lastLocation = [self.locations lastObject];
    
    return [[LFTimeInterval alloc] initWithStartDate:firstLocation.timestamp
                                             endDate:lastLocation.timestamp];
}

@end
