//
//  MapViewController.m
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"
#import "FlickrImageAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

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
    static NSString *placeIdentifier = @"Place";
    static NSString *imageIdentifier = @"Image";
    if([annotation isKindOfClass:[FlickrPlaceAnnotation class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:placeIdentifier];
        if(!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placeIdentifier];
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = button;
        }        
        annotationView.annotation = annotation;
        return annotationView;
    }
    else if([annotation isKindOfClass:[FlickrImageAnnotation class]]){
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:imageIdentifier];
        if(!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:imageIdentifier];
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = button;
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
        
        [(UIImageView *)annotationView.leftCalloutAccessoryView setImage:nil];
        
        annotationView.annotation = annotation;
        return annotationView;
    }
    else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapView:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

@end
