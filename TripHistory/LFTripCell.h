//
//  LFTripCell.h
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFTrip;
@class LFTripsManager;

@interface LFTripCell : UITableViewCell

- (void)updateWithTrip:(LFTrip *)trip tripsManager:(LFTripsManager *)tripsManager;

@end
