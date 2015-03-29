//
//  UITableView+LFExtensions.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "UITableView+LFExtensions.h"

@implementation UITableView (LFExtensions)

- (UITableViewCell *)lf_dequeueOrCreateCellWithStyle:(UITableViewCellStyle)style
                                     reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        return [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    else
    {
        return cell;
    }
}

@end
