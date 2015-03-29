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

@interface LFTripDetailViewController () <MKMapViewDelegate>

@property (nonatomic, readwrite, strong) IBOutlet MKMapView *mapView;

@end

@implementation LFTripDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadDataAnimated:NO];
}

- (void)reloadDataAnimated:(BOOL)animated
{
    NSArray *locations = self.trip.locations;
    CLLocationCoordinate2D coordinates[locations.count];
    for (NSInteger i = 0; i < locations.count; i++)
    {
        coordinates[i] = [locations[i] coordinate];
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:locations.count];
    [self.mapView addOverlay:polyline];
    
    [self.mapView setRegion:[self coordinateRegionFromLocations:locations]
                   animated:animated];
}

- (MKCoordinateRegion)coordinateRegionFromLocations:(NSArray *)locations
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

#pragma mark - MKMapKitDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [[UIColor lf_lyftTitleColor] colorWithAlphaComponent:0.5f];
        renderer.lineWidth = 10.0f;
        return renderer;
    }
    
    return nil;
}

@end
