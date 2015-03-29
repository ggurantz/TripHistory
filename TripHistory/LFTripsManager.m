//
//  LFTripsManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripsManager.h"
#import "LFActiveTripManager.h"

@interface LFTripsManager ()

@property (nonatomic, readwrite, strong) NSMutableArray *trips;
@property (nonatomic, readwrite, strong) LFActiveTripManager *activeTripManager;

@end

@implementation LFTripsManager

- (instancetype)init
{
    return self;
}

- (instancetype)initWithActiveTripManager:(LFActiveTripManager *)activeTripManager
{
    self = [super init];
    if (self) {
        self.trips = [NSMutableArray array];
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

@end
