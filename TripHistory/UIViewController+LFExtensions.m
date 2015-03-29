//
//  UIViewController+LFExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "UIViewController+LFExtensions.h"

@implementation UIViewController (LFExtensions)

+ (instancetype)lf_createFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(self)
                                                         bundle:nil];
    return [storyboard instantiateInitialViewController];
}

@end
