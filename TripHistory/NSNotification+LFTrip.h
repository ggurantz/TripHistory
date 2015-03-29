//
//  NSNotification+LFTrip.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFTrip;

extern NSString *const kNSNotificationTripKey;

@interface NSNotification (LFTrip)

- (LFTrip *)trip;

@end

@interface NSNotificationCenter (LFTrip)

- (void)postNotificationName:(NSString *)aName object:(id)anObject trip:(LFTrip *)trip;

@end