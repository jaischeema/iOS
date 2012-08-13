//
//  MapViewController.h
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@class MapViewController;

@protocol MapViewDelegate

- (UIImage *) mapView:(MapViewController *)mapViewController imageForAnnotation:(id <MKAnnotation>)annotation;

@optional

- (void) mapView:(MapViewController *)mapViewController detailedActionForAnnotation:(id <MKAnnotation>) annotation;

@end

@interface MapViewController : UIViewController
@property (nonatomic,strong) NSArray *annotations;
@property (nonatomic,weak) id <MapViewDelegate> delegate;
@end
