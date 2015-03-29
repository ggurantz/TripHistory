//
//  LFTripsManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripsManager.h"
#import "LFActiveTripManager.h"

@interface LFTripsManager () <LFActiveTripManagerDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray *trips;
@property (nonatomic, readwrite, strong) LFActiveTripManager *activeTripManager;

@end

@implementation LFTripsManager

- (instancetype)init
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
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didUpdateTrip:(LFTrip *)trip
{
    
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didCompleteTrip:(LFTrip *)trip
{
    
}

- (void)activeTripManager:(LFActiveTripManager *)tripManager didFailAuthorizationWithError:(NSError *)error
{
    self.loggingEnabled = NO;
}

@end
