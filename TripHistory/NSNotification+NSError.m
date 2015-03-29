//
//  NSNotification+NSError.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "NSNotification+NSError.h"

NSString *const kNSNotificationErrorKey = @"kNSNotificationErrorKey";

@implementation NSNotification (NSError)

- (NSError *)error
{
    return [self.userInfo objectForKey:kNSNotificationErrorKey];
}

@end


@implementation NSNotificationCenter (NSError)

- (void)postNotificationName:(NSString *)aName object:(id)anObject error:(NSError *)error
{
    NSDictionary *userInfo = @{ kNSNotificationErrorKey: error };
    [self postNotificationName:aName object:anObject userInfo:userInfo];
}

@end