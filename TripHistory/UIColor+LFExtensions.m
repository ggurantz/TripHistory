//
//  UIColor+LFExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "UIColor+LFExtensions.h"

@implementation UIColor (LFExtensions)

+ (UIColor *)lf_cellTitleColor
{
    return [UIColor colorWithRed:(102.0f/256.0f)
                           green:(100.0f/256.0f)
                            blue:(97.0f/256.0f)
                           alpha:1.0];
}

+ (UIColor *)lf_lyftTitleColor
{
    return [UIColor colorWithRed:(0.0f/256.0f)
                           green:(180.0f/256.0f)
                            blue:(174.0f/256.0f)
                           alpha:1.0];
}

@end
