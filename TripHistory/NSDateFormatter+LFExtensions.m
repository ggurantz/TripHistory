//
//  NSDateFormatter+LFExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "NSDateFormatter+LFExtensions.h"

@implementation NSDateFormatter (LFExtensions)

+ (instancetype)lf_timeOfDayDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return dateFormatter;
}

@end
