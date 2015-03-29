//
//  LFTripDetailViewController.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFTrip;

@interface LFTripDetailViewController : UIViewController

@property (nonatomic, readwrite, strong) LFTrip *trip;

@end
