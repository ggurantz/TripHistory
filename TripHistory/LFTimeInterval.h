//
//  LFTimeInterval.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFTimeInterval : NSObject

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

- (NSDate *)startDate;
- (NSDate *)endDate;
- (NSTimeInterval)duration;

@end