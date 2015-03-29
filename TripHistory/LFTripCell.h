//
//  LFTripCell.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFTripCell : UITableViewCell

@property (nonatomic, readwrite, strong) IBOutlet UILabel *startLocationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *endLocationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UIActivityIndicatorView *startActivityIndicator;
@property (nonatomic, readwrite, strong) IBOutlet UIActivityIndicatorView *endActivityIndicator;
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *chevronImageView;
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *carImageView;

@property (nonatomic, readwrite, strong) IBOutlet UILabel *timeIntervalLabel;

@end
