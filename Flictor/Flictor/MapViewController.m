//
//  MapViewController.m
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "FlickrPlaceAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;

- (void) updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) 
    {
        [self.mapView addAnnotations:self.annotations];
    }
    [self.mapView reloadInputViews];
}

- (void) setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapView];
}

- (void) setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (IBAction)changeMapType:(id)sender 
{
    if([sender isKindOfClass:[UISegmentedControl class]])
    {        
        UISegmentedControl *segment = (UISegmentedControl *)sender;
        if(segment.selectedSegmentIndex == 0)
        {
            self.mapView.mapType = MKMapTypeStandard;
        }
        else if(segment.selectedSegmentIndex == 1)
        {
            self.mapView.mapType = MKMapTypeSatellite;
        }
        else if(segment.selectedSegmentIndex == 2)
        {
            self.mapView.mapType = MKMapTypeHybrid;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark MKMapViewDelegate

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"Place";
    if([annotation isKindOfClass:[FlickrPlaceAnnotation class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if(!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
        }
        annotationView.annotation = annotation;
        return annotationView;
    }
    else {
        return nil;
    }
}

@end
