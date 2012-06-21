//
//  FlickrAnnotation.m
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrAnnotation

@synthesize photo = _photo;

+ (FlickrAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrAnnotation *annotation = [[FlickrAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D cord;
    cord.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    cord.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return cord;
}

- (NSString *) title
{
    return [self.photo objectForKey:FLICKR_PLACE_NAME];
}

- (NSString *) subtitle
{
    return [self.photo valueForKeyPath:FLICKR_PLACE_NAME];
}



@end
