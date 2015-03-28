//
//  THLocationManager.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFLocationManager.h"
#import "NSError+LFExtensions.h"
#import <CoreLocation/CoreLocation.h>

@interface LFLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
@property (nonatomic, readwrite, weak) id<THLocationManagerDelegate> delegate;

@end

@implementation LFLocationManager

- (instancetype)init
{
    NSAssert(NO, @"Use -initWithDelegate");
    return nil;
}

- (instancetype)initWithDelegate:(id<THLocationManagerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)failWithError:(NSError *)error
{
    [self.delegate locationManager:self didFailWithError:error];
}

- (void)handleAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestAlwaysAuthorization];
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            NSString *errorString = [NSString stringWithFormat:@"Not authorized to use location services. Status: %d", status];
            NSError *error = [NSError errorWithLocalizedDescription:errorString];
            [self failWithError:error];
        }
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
    }
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self handleAuthorizationStatus:status];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self failWithError:error];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}

@end
