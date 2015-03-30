//
//  THTrip.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LFTimeInterval;

typedef NS_ENUM(NSInteger, LFTripState) {
    LFTripStateActive,
    LFTripStateCompleted
};

typedef NS_ENUM(NSInteger, LFTripActivityType) {
    LFTripActivityTypeDriving,
    LFTripActivityTypeCycling,
    LFTripActivityTypeRunning
};

@interface LFTrip : NSObject <NSCoding>

- (instancetype)initWithLocations:(NSArray *)locations;

@property (nonatomic, readonly, strong) NSArray *locations;
- (LFTripState)state;
- (CLLocation *)startLocation;
- (CLLocation *)endLocation;
- (LFTimeInterval *)timeInterval;

@property (nonatomic, readwrite, strong) NSString *startLocationAddress;
@property (nonatomic, readwrite, strong) NSString *endLocationAddress;
@property (nonatomic, readwrite, assign) LFTripActivityType activityType;

@end
