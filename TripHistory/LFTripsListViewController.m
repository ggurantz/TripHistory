//
//  LFTripsListViewController.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/28/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripsListViewController.h"
#import "UITableView+LFExtensions.h"
#import "UIColor+LFExtensions.h"
#import "LFTripsManager.h"
#import "NSNotification+NSError.h"
#import "NSNotification+LFTrip.h"
#import "LFTrip.h"
#import "LFTimeInterval.h"
#import "NSDateFormatter+LFExtensions.h"
#import "LFTripCell.h"
#import "LFTripDetailViewController.h"
#import "UIViewController+LFExtensions.h"

@interface LFTripsListViewController ()

@property (nonatomic, readwrite, strong) LFTripsManager *tripsManager;
@property (nonatomic, readwrite, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch *loggingSwitch;

@end

@implementation LFTripsListViewController

- (void)dealloc
{
    [_notificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tripsManager = [[LFTripsManager alloc] init];
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.notificationCenter addObserver:self
                                selector:@selector(tripsManagerDidBeginNewTrip:)
                                    name:LFTripsManagerDidBeginNewTripNotification
                                  object:self.tripsManager];
    [self.notificationCenter addObserver:self
                                selector:@selector(tripsManagerDidUpdateTrip:)
                                    name:LFTripsManagerDidUpdateTripNotification
                                  object:self.tripsManager];
    [self.notificationCenter addObserver:self
                                selector:@selector(tripsManagerDidCompleteTrip:)
                                    name:LFTripsManagerDidCompleteTripNotification
                                  object:self.tripsManager];
    [self.notificationCenter addObserver:self
                                selector:@selector(tripsManagerDidFailAuthorization:)
                                    name:LFTripsManagerDidFailAuthorization
                                  object:self.tripsManager];
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.loggingSwitch.onTintColor = [UIColor lf_lyftTitleColor];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self.loggingSwitch setOn:self.tripsManager.loggingEnabled];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:true];
}

#pragma mark - LFTripsManager

- (IBAction)loggingEnabledButtonValueChanged:(UISwitch *)loggingSwitch
{
    self.tripsManager.loggingEnabled = loggingSwitch.isOn;
}

- (void)tripsManagerDidBeginNewTrip:(NSNotification *)notification
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
}

- (void)tripsManagerDidUpdateTrip:(NSNotification *)notification
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tripsManagerDidCompleteTrip:(NSNotification *)notification
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tripsManagerDidFailAuthorization:(NSNotification *)notification
{
    [self.loggingSwitch setOn:NO animated:YES];
    
    NSError *error = [notification error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tripsManager.allTrips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFTrip *trip = [self.tripsManager.allTrips objectAtIndex:indexPath.row];
    LFTripCell *tripCell = (LFTripCell *)[tableView dequeueReusableCellWithIdentifier:@"LFTripCell"
                                                                         forIndexPath:indexPath];
    
    tripCell.layoutMargins = UIEdgeInsetsZero;
    
    [self updateAddresLabel:tripCell.startLocationLabel
          activityIndicator:tripCell.startActivityIndicator
                withAddress:[self.tripsManager startAddressForTrip:trip]];
    
    NSString *timeIntervalString = nil;
    LFTimeInterval *timeInterval = trip.timeInterval;
    NSInteger minutes = timeInterval.duration / 60;
    
    NSDateFormatter *timeDateFormatter = [NSDateFormatter lf_timeOfDayDateFormatter];
    NSString *startTimeString = [timeDateFormatter stringFromDate:timeInterval.startDate];
    
    switch (trip.state) {
        case LFTripStateActive:
            timeIntervalString = startTimeString;
            tripCell.carImageView.image = [UIImage imageNamed:@"CarIconActive"];
            tripCell.carImageView.alpha = 1.0f;
            tripCell.chevronImageView.hidden = YES;
            tripCell.endLocationLabel.text = @"";
            break;
            
        case LFTripStateCompleted:
        {
            NSString *endTimeString = [timeDateFormatter stringFromDate:timeInterval.endDate];
            timeIntervalString = [NSString stringWithFormat:@"%@-%@",
                                  startTimeString,
                                  endTimeString];
            
            tripCell.carImageView.image = [UIImage imageNamed:@"CarIcon"];
            tripCell.chevronImageView.hidden = NO;
            tripCell.carImageView.alpha = 0.5f;
            
            [self updateAddresLabel:tripCell.endLocationLabel
                  activityIndicator:tripCell.endActivityIndicator
                        withAddress:[self.tripsManager endAddressForTrip:trip]];
        }
            break;
    }
    
    tripCell.timeIntervalLabel.text = [NSString stringWithFormat:@"%@ (%zdmin)", timeIntervalString, minutes];
    
    return tripCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFTrip *trip = [self.tripsManager.allTrips objectAtIndex:indexPath.row];
    LFTripDetailViewController *viewController = [LFTripDetailViewController lf_createFromStoryboard];
    viewController.trip = trip;
    
    [self.navigationController pushViewController:viewController animated:true];
}

@end
