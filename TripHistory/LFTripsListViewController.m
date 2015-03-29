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

@interface LFTripsListViewController ()

@property (nonatomic, readwrite, strong) LFTripsManager *tripsManager;

@end

@implementation LFTripsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0: return 1;
        case 1: return 0;
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
            switchCell.layoutMargins = UIEdgeInsetsZero;
            switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return switchCell;
        }
            break;
            
        case 1:
            return nil;
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
