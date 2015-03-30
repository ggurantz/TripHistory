//
//  LFActionCompletedView.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFActionCompletedView.h"
#import "NSObject+LFNibExtensions.h"

@interface LFActionCompletedView ()

@property (nonatomic, readwrite, strong) IBOutlet UIView *backgroundView;

@end

@implementation LFActionCompletedView

+ (void)showAndDismissInView:(UIView *)parentView
{
    LFActionCompletedView *view = [self loadFromNib];
    view.center = CGPointMake(parentView.bounds.size.width/2,
                              parentView.bounds.size.height * 0.333f);
    view.backgroundView.layer.cornerRadius = 8.0f;
    
    [parentView addSubview:view];
    
    view.alpha = 0.0f;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9f, 0.9f);
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.0
                        options:0.0f
                     animations:^{
                         view.alpha = 1.0f;
                         view.transform = CGAffineTransformIdentity;
                     }
     completion:^(BOOL finished) {
         if (finished)
         {
             [UIView animateWithDuration:0.3f
                                   delay:1.0f
                                 options:0
                              animations:^{
                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9f, 0.9f);
                                  view.alpha = 0.0f;
                              }
                              completion:^(BOOL finished) {
                                  [view removeFromSuperview];
                              }];
         }
     }];
}

@end
