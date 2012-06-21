//
//  FlickrAnnotation.h
//  Flictor
//
//  Created by Jais Cheema on 21/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>
@property (nonatomic,strong) NSDictionary *photo;
+ (FlickrAnnotation *) annotationForPhoto:(NSDictionary *)photo;
@end
