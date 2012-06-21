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
    FlickrAnnotation *ann = [[FlickrAnnotation alloc] init];
    ann.photo = photo;
    return ann;
}

- (NSString *) title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *) description
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
