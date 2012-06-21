//
//  FlickrPlaceAnnotation.m
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

@synthesize place  = _place;

- (NSString *) title
{
    return [FlickrFetcher titleForPlace:self.place];
}

- (NSString *) subtitle
{
    return [FlickrFetcher subtitleForPlace:self.place];
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D cord;
    cord.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    cord.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    return cord;
}

+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    
    return annotation;
}

@end
