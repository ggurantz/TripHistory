//
//  NSNotification+NSError.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (NSError)

- (NSError *)error;

@end

@interface NSNotificationCenter (NSError)

- (void)postNotificationName:(NSString *)aName object:(id)anObject error:(NSError *)error;

@end