//
//  LFTripCell.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripCell.h"
#import "LFTripsManager.h"
#import "LFTrip.h"
#import "LFTimeInterval.h"
#import "LFTimeOfDayFormatter.h"

@interface LFTripCell ()

@property (nonatomic, readwrite, strong) IBOutlet UILabel *startLocationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *endLocationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UIActivityIndicatorView *startActivityIndicator;
@property (nonatomic, readwrite, strong) IBOutlet UIActivityIndicatorView *endActivityIndicator;
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *chevronImageView;
@property (nonatomic, readwrite, strong) IBOutlet UIImageView *carImageView;

@property (nonatomic, readwrite, strong) IBOutlet UILabel *timeIntervalLabel;

@end

@implementation LFTripCell

- (void)updateAddresLabel:(UILabel *)label
        activityIndicator:(UIActivityIndicatorView *)activityIndicator
              withAddress:(NSString *)address
{
    if (address.length > 0)
    {
        label.text = address;
        [activityIndicator stopAnimating];
    }
    else
    {
        label.text = @"";
        [activityIndicator startAnimating];
    }
}

- (void)updateWithTrip:(LFTrip *)trip tripsManager:(LFTripsManager *)tripsManager
{
    [self updateAddresLabel:self.startLocationLabel
          activityIndicator:self.startActivityIndicator
                withAddress:[tripsManager startAddressForTrip:trip]];
    
    NSString *timeIntervalString = nil;
    LFTimeInterval *timeInterval = trip.timeInterval;
    NSInteger minutes = timeInterval.duration / 60;
    
    NSDateFormatter *timeDateFormatter = [LFTimeOfDayFormatter sharedFormatter];
    NSString *startTimeString = [timeDateFormatter stringFromDate:timeInterval.startDate];
    
    switch (trip.state) {
        case LFTripStateActive:
            timeIntervalString = startTimeString;
            self.carImageView.image = [UIImage imageNamed:@"CarIconActive"];
            self.carImageView.alpha = 1.0f;
            self.chevronImageView.hidden = YES;
            self.endLocationLabel.text = @"";
            break;
            
        case LFTripStateCompleted:
        {
            NSString *endTimeString = [timeDateFormatter stringFromDate:timeInterval.endDate];
            timeIntervalString = [NSString stringWithFormat:@"%@-%@",
                                  startTimeString,
                                  endTimeString];
            
            self.carImageView.image = [UIImage imageNamed:@"CarIcon"];
            self.chevronImageView.hidden = NO;
            self.carImageView.alpha = 0.5f;
            
            [self updateAddresLabel:self.endLocationLabel
                  activityIndicator:self.endActivityIndicator
                        withAddress:[tripsManager endAddressForTrip:trip]];
        }
            break;
    }
    
    self.timeIntervalLabel.text = [NSString stringWithFormat:@"%@ (%zdmin)", timeIntervalString, minutes];
}

@end
