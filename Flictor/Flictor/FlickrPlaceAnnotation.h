//
//  FlickrPlaceAnnotation.h
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import <Mapkit/Mapkit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>
@property (nonatomic,strong) NSDictionary *place;
+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place;
@end