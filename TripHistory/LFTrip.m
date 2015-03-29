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

- (instancetype)init
{
    return [self initWithLocations:nil];
}

- (instancetype)initWithLocations:(NSArray *)locations
{
    NSAssert(locations.count > 0, @"A trip must have at least one location");
    
    self = [super init];
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

- (CLLocation *)startLocation
{
    if (self.locations.count > 0)
    {
        return self.locations[0];
    }
    else
    {
        return nil;
    }
}

- (CLLocation *)endLocation
{
    return self.locations.lastObject;
}

- (LFTimeInterval *)timeInterval
{
    NSAssert(self.locations.count > 0, @"A trip must have at least one location");
    
    return [[LFTimeInterval alloc] initWithStartDate:self.startLocation.timestamp
                                             endDate:self.endLocation.timestamp];
}

@end
