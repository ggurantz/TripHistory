//
//  UITableView+LFExtensions.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LFExtensions)

- (UITableViewCell *)lf_dequeueOrCreateCellWithStyle:(UITableViewCellStyle)style
                                     reuseIdentifier:(NSString *)reuseIdentifier;

- (id)lf_dequeueCellClass:(Class)aClass;
- (void)lf_registerCellClass:(Class)aClass;

@end
