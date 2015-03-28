//
//  NSError+THExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "NSError+LFExtensions.h"

NSString *const kTHErrorDomain = @"kTHErrorDomain";
NSInteger const kTHDefaultErrorCode = 0;

@implementation NSError (LFExtensions)

+ (id)errorWithLocalizedDescription:(NSString *)localizedDescription
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: localizedDescription };
    return [NSError errorWithDomain:kTHErrorDomain code:kTHDefaultErrorCode userInfo:userInfo];
}

@end
