//
//  THLocationManager.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLocationManagerDelegate;

@interface LFLocationManager : NSObject

- (instancetype)initWithDelegate:(id<THLocationManagerDelegate>)delegate;

@end

@protocol THLocationManagerDelegate <NSObject>

- (void)locationManager:(LFLocationManager *)locationManager didFailWithError:(NSError *)error;

@end