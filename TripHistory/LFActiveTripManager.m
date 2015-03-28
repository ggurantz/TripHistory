//
//  THActiveTripManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFActiveTripManager.h"
#import "LFLocationManager.h"

@interface LFActiveTripManager () <LFLocationManagerDelegate>

@property (nonatomic, readwrite, weak) id<LFActiveTripManagerDelegate> delegate;

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

#pragma mark - LFLocationManagerDelegate

- (void)locationManager:(LFLocationManager *)locationManager didFailAuthorizationWithError:(NSError *)error
{
    [self.delegate activeTripManager:self didFailAuthorizationWithError:error];
}

@end
