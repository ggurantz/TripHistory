//
//  LFTripDetailViewController.m
//  TripHistory
//
//  Created by Gilad Gurantz on 3/29/15.
//  Copyright (c) 2015 Lyft. All rights reserved.
//

#import "LFTripDetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+LFExtensions.h"
#import "LFTrip.h"
#import "LFTripsManager.h"
#import "NSNotification+LFTrip.h"
#import "LFTripCell.h"
#import "UITableView+LFExtensions.h"
#import "LFActionCompletedView.h"

@interface LFTripDetailViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, readwrite, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, readwrite, strong) MKPolyline *polyline;

@property (nonatomic, readwrite, strong) MKPointAnnotation *startPointAnnotation;
@property (nonatomic, readwrite, strong) MKPointAnnotation *carAnnotation;
@property (nonatomic, readwrite, strong) MKPointAnnotation *endPointAnnotation;

@property (nonatomic, readwrite, strong) IBOutlet UITableView *tableView;

@end

@implementation LFTripDetailViewController

- (void)dealloc
{
    [_notificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView lf_registerCellClass:[LFTripCell class]];
    
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    [self.notificationCenter addObserver:self
                                selector:@selector(tripsManagerDidUpdateTrip:)
                                    name:LFTripsManagerDidUpdateTripNotification
                                  object:self.tripsManager];
    
    self.startPointAnnotation = [[MKPointAnnotation alloc] init];
    self.startPointAnnotation.title = self.trip.startLocationAddress;
    self.startPointAnnotation.coordinate = self.trip.startLocation.coordinate;
    [self.mapView addAnnotation:self.startPointAnnotation];
    
    switch (self.trip.state) {
        case LFTripStateActive:
            [self.notificationCenter addObserver:self
                                        selector:@selector(tripsManagerDidCompleteTrip:)
                                            name:LFTripsManagerDidCompleteTripNotification
                                          object:self.tripsManager];
            
            self.carAnnotation = [[MKPointAnnotation alloc] init];
            self.carAnnotation.coordinate = self.trip.endLocation.coordinate;
            [self.mapView addAnnotation:self.carAnnotation];
            break;
            
        case LFTripStateCompleted:
            [self createAndAddEndPointAnnotation];
            break;
    }
    
    [self reloadDataAnimated:NO];
}

- (void)createAndAddEndPointAnnotation
{
    self.endPointAnnotation = [[MKPointAnnotation alloc] init];
    self.endPointAnnotation.title = self.trip.endLocationAddress;
    self.endPointAnnotation.coordinate = self.trip.endLocation.coordinate;
    [self.mapView addAnnotation:self.endPointAnnotation];
}

- (void)reloadDataAnimated:(BOOL)animated
{
    NSArray *locations = self.trip.locations;
    CLLocationCoordinate2D coordinates[locations.count];
    for (NSInteger i = 0; i < locations.count; i++)
    {
        coordinates[i] = [locations[i] coordinate];
    }
    
    [self.mapView removeOverlay:self.polyline];
    
    __block LFTripDetailViewController *blockSelf = self;
    [UIView animateWithDuration:(animated ? 0.1 : 0.0)
                     animations:^{
                         blockSelf.carAnnotation.coordinate = [locations.lastObject coordinate];
                     }];
    
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:locations.count];
    [self.mapView addOverlay:self.polyline];
    
    [self.mapView setRegion:[self coordinateRegionFromLocations:locations]
                   animated:animated];
    
    if (animated)
    {
        [self reloadTableViewAnimated];
    }
}

#pragma mark - LFTripsManager

- (void)tripsManagerDidUpdateTrip:(NSNotification *)notification
{
    if (self.trip == [notification trip])
    {
        [self reloadDataAnimated:YES];
    }
}

- (void)tripsManagerDidCompleteTrip:(NSNotification *)notification
{
    if (self.trip == [notification trip])
    {
        [self.mapView removeAnnotation:self.carAnnotation];
        self.carAnnotation = nil;
        
        [self createAndAddEndPointAnnotation];
        [self reloadDataAnimated:YES];
        [LFActionCompletedView showAndDismissInView:self.view];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:LFTripsManagerDidCompleteTripNotification
                                                      object:self.tripsManager];
    }
}

#pragma mark - MKMapKit

- (MKCoordinateRegion)coordinateRegionFromLocations:(NSArray *)locations
{
    MKCoordinateRegion coordinateRegion = [self fullViewCoordinateRegionFromLocations:locations];
    
    switch (self.trip.state) {
        case LFTripStateActive:
            coordinateRegion.center = [locations.lastObject coordinate];
            break;
            
        case LFTripStateCompleted:
            break;
    }
    
    return coordinateRegion;
}
- (MKCoordinateRegion)fullViewCoordinateRegionFromLocations:(NSArray *)locations
{
    CLLocationDegrees minLat = 90.0f;
    CLLocationDegrees maxLat = -90.0f;
    CLLocationDegrees minLon = 180.0f;
    CLLocationDegrees maxLon = -180.0f;
    
    for (CLLocation *location in locations) {
        minLat = MIN(location.coordinate.latitude, minLat);
        minLon = MIN(location.coordinate.longitude, minLon);
        maxLat = MAX(location.coordinate.latitude, maxLat);
        maxLon = MAX(location.coordinate.longitude, maxLon);
    }
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 2,
                                                               maxLon - span.longitudeDelta / 2);
    
    return MKCoordinateRegionMake(center, MKCoordinateSpanMake(span.latitudeDelta * 2.0f,
                                                               span.longitudeDelta * 2.0f));
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [[UIColor lf_lyftTitleColor] colorWithAlphaComponent:0.5f];
        renderer.lineWidth = 6.0f;
        return renderer;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.carAnnotation)
    {
        MKAnnotationView *carAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                       reuseIdentifier:@"carAnnotationReuseIdentifier"];
        
        carAnnotation.image = [UIImage imageNamed:@"CarIcon"];
        return carAnnotation;
    }
    else
    {
        MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinAnnotationReuseIdentifier"];
        pinAnnotation.canShowCallout = YES;
        
        if (annotation == self.startPointAnnotation)
        {
            pinAnnotation.pinColor = MKPinAnnotationColorRed;
        }
        else if (annotation == self.endPointAnnotation)
        {
            pinAnnotation.pinColor = MKPinAnnotationColorGreen;
        }
        
        return pinAnnotation;
    }
}

#pragma mark - UITableView

- (void)reloadTableViewAnimated
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0
                                                                inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFTrip *trip = [self.tripsManager.allTrips objectAtIndex:indexPath.row];
    LFTripCell *tripCell = [tableView lf_dequeueCellClass:[LFTripCell class]];
    
    tripCell.layoutMargins = UIEdgeInsetsZero;
    [tripCell updateWithTrip:trip tripsManager:self.tripsManager];
    
    return tripCell;
}

@end
