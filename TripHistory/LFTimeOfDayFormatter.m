//
//  LFTimeOfDayFormatter.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTimeOfDayFormatter.h"

@implementation LFTimeOfDayFormatter

+ (instancetype)sharedFormatter
{
    static LFTimeOfDayFormatter *theSharedFormatter = nil;
    
    if (theSharedFormatter == nil)
    {
        theSharedFormatter = [[self alloc] init];
    }
    
    return theSharedFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateStyle = NSDateFormatterNoStyle;
        self.timeStyle = NSDateFormatterShortStyle;
        
    }
    return self;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSString *string = [super stringFromDate:date];
    string = [string lowercaseString];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

@end
