//
//  NSError+THExtensions.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kTHErrorDomain;
extern NSInteger const kTHDefaultErrorCode;

@interface NSError (LFExtensions)

+ (id)errorWithLocalizedDescription:(NSString *)localizedDescription;

@end
