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

- (id)lf_dequeueCellClass:(Class)aClass
{
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(aClass)];
}

- (void)lf_registerCellClass:(Class)aClass
{
    NSString *name = NSStringFromClass(aClass);
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:name];
}

@end
