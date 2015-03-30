//
//  NSObject+LFNibExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "NSObject+LFNibExtensions.h"
#import <UIKit/UIKit.h>

@implementation NSObject (LFNibExtensions)

+ (instancetype)loadFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self)
                                                   owner:nil
                                                 options:nil];
    
    NSAssert(views.count > 0, @"View not found");
    return views[0];
}

@end
