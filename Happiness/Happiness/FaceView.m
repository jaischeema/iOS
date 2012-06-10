//
//  FaceView.m
//  Happiness
//
//  Created by Jais Cheema on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context 
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

#define DEFAULT_SCALE 0.90

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat radius = self.bounds.size.width/2;
    if(self.bounds.size.width > self.bounds.size.height)
    {
        radius = self.bounds.size.height/2;
    }
    radius = DEFAULT_SCALE * radius;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];

    [self drawCircleAtPoint:midPoint withRadius:radius inContext:context];
}


@end
