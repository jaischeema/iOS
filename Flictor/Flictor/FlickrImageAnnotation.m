//
//  FlickrImageAnnotation.m
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "FlickrImageAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrImageAnnotation

@synthesize image = _image;

- (NSString *) title
{
    return [FlickrFetcher titleForImage:self.image];
}

- (NSString *) subtitle
{
    return [FlickrFetcher subtitleForImage:self.image];
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D cord;
    cord.latitude = [[self.image objectForKey:FLICKR_LATITUDE] doubleValue];
    cord.longitude = [[self.image objectForKey:FLICKR_LONGITUDE] doubleValue];
    
    return cord;
}

+ (FlickrImageAnnotation *) annotationForImage:(NSDictionary *)image
{
    FlickrImageAnnotation *annotation = [[FlickrImageAnnotation alloc] init];
    annotation.image = image;
    
    return annotation;
}

@end
