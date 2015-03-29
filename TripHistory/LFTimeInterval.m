//
//  LFTimeInterval.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTimeInterval.h"

@interface LFTimeInterval ()

@property (nonatomic, readwrite, strong) NSDate *startDate;
@property (nonatomic, readwrite, strong) NSDate *endDate;

@end

@implementation LFTimeInterval

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self = [super init];
    if (self) {
        self.startDate = startDate;
        self.endDate = endDate;
    }
    return self;
}

- (NSTimeInterval)duration
{
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

@end
