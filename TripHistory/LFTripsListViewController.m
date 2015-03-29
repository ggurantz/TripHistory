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

@interface LFTripsListViewController ()

@property (nonatomic, readwrite, strong) LFTripsManager *tripsManager;
@property (nonatomic, readwrite, strong) NSNotificationCenter *notificationCenter;

@end

@implementation LFTripsListViewController

- (void)dealloc
{
    [_notificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.tripsManager = [[LFTripsManager alloc] init];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LFTripsManager

- (void)loggingEnabledButtonValueChanged:(UISwitch *)loggingSwitch
{
    self.tripsManager.loggingEnabled = loggingSwitch.isOn;
}

- (void)tripsManagerDidBeginNewTrip:(NSNotification *)notification
{
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                          withRowAnimation:UITableViewRowAnimationTop];
}

- (void)tripsManagerDidUpdateTrip:(NSNotification *)notification
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tripsManagerDidCompleteTrip:(NSNotification *)notification
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tripsManagerDidFailAuthorization:(NSNotification *)notification
{
    [self.tableView reloadData];
    
    NSError *error = [notification error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0: return 1;
        case 1: return self.tripsManager.allTrips.count;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell *switchCell = [tableView lf_dequeueOrCreateCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"];
            
            switchCell.layoutMargins = UIEdgeInsetsZero;
            
            UISwitch *loggingEnabledSwitch = [[UISwitch alloc] init];
            loggingEnabledSwitch.onTintColor = [UIColor lf_lyftTitleColor];
            [loggingEnabledSwitch setOn:self.tripsManager.loggingEnabled animated:NO];
            [loggingEnabledSwitch addTarget:self
                                     action:@selector(loggingEnabledButtonValueChanged:)
                           forControlEvents:UIControlEventValueChanged];
            
            switchCell.accessoryView = loggingEnabledSwitch;
            
            switchCell.textLabel.text = @"Trip Logging";
            switchCell.textLabel.textColor = [UIColor lf_cellTitleColor];
            switchCell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];

            switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return switchCell;
        }
            break;
            
        case 1:
        {
            LFTrip *trip = [self.tripsManager.allTrips objectAtIndex:indexPath.row];
            UITableViewCell *tripCell = [tableView lf_dequeueOrCreateCellWithStyle:UITableViewCellStyleSubtitle
                                                                   reuseIdentifier:@"TripCell"];
            
            tripCell.layoutMargins = UIEdgeInsetsZero;
            
            tripCell.imageView.image = [UIImage imageNamed:@"CarIcon"];
            
            tripCell.textLabel.textColor = [UIColor lf_cellTitleColor];
            tripCell.textLabel.text = @"Title";
            tripCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            
            NSString *timeIntervalString = nil;
            LFTimeInterval *timeInterval = trip.timeInterval;
            NSInteger minutes = timeInterval.duration / 60;
            
            NSDateFormatter *timeDateFormatter = [NSDateFormatter lf_timeOfDayDateFormatter];
            NSString *startTimeString = [timeDateFormatter stringFromDate:timeInterval.startDate];
            
            switch (trip.state) {
                case LFTripStateActive:
                    timeIntervalString = startTimeString;
                    break;
                    
                case LFTripStateCompleted:
                {
                    NSString *endTimeString = [timeDateFormatter stringFromDate:timeInterval.endDate];
                    timeIntervalString = [NSString stringWithFormat:@"%@-%@",
                                          startTimeString,
                                          endTimeString];
                }
                    break;
            }
            
            tripCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%zdmin)", timeIntervalString, minutes];
            tripCell.detailTextLabel.textColor = [UIColor grayColor];
            tripCell.detailTextLabel.font = [UIFont italicSystemFontOfSize:13.0];
            
            return tripCell;
        }
            break;
            
        default:
            NSAssert(NO, @"Invalid section");
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 72.0f;
    }
    else
    {
        return tableView.rowHeight;
    }
}

@end
