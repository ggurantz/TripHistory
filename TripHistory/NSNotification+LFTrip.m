//
//  NSNotification+LFTrip.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "NSNotification+LFTrip.h"

NSString *const kNSNotificationTripKey = @"kNSNotificationTripKey";

@implementation NSNotification (LFTrip)

- (LFTrip *)trip
{
    return [self.userInfo objectForKey:kNSNotificationTripKey];
}

@end


@implementation NSNotificationCenter (LFTrip)

- (void)postNotificationName:(NSString *)aName object:(id)anObject trip:(LFTrip *)trip
{
    NSDictionary *userInfo = @{ kNSNotificationTripKey: trip };
    [self postNotificationName:aName object:anObject userInfo:userInfo];
}

@end