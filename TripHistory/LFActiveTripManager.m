//
//  THActiveTripManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFActiveTripManager.h"
#import "LFLocationManager.h"
#import "LFActiveTrip.h"

CLLocationSpeed const kLFActiveTripManagerTripStartSpeed = 4.4704f; // 10 mph
CLLocationSpeed const kLFActiveTripManagerMinimumActivitySpeed = 0.44704f; // 1 mph
NSTimeInterval const kLFActiveTripManagerTripEndIdleTimeInterval = 60.0f; // 1 minute

@interface LFActiveTripManager ()

@property (nonatomic, readwrite, weak) id<LFActiveTripManagerDelegate> delegate;
@property (nonatomic, readwrite, strong) LFActiveTrip *activeTrip;

@end

@implementation LFActiveTripManager

- (instancetype)initWithDelegate:(id<LFActiveTripManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (LFTrip *)trip
{
    return self.activeTrip;
}

#pragma mark - LFLocationManagerDelegate

- (void)locationManager:(LFLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    
}

- (void)locationManager:(LFLocationManager *)locationManager didFailAuthorizationWithError:(NSError *)error
{
    [self.delegate activeTripManager:self didFailAuthorizationWithError:error];
}

@end
