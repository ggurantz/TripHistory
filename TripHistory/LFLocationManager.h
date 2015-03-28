//
//  THLocationManager.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LFLocationManagerDelegate;

@interface LFLocationManager : NSObject

- (instancetype)initWithDelegate:(id<LFLocationManagerDelegate>)delegate;

@end

@protocol LFLocationManagerDelegate <NSObject>

- (void)locationManager:(LFLocationManager *)locationManager didFailAuthorizationWithError:(NSError *)error;

@end