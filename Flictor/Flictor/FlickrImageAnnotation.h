//
//  FlickrImageAnnotation.h
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import <Mapkit/Mapkit.h>

@interface FlickrImageAnnotation : NSObject <MKAnnotation>
@property (nonatomic,strong) NSDictionary *image;
+ (FlickrImageAnnotation *) annotationForImage:(NSDictionary *)image;
@end
