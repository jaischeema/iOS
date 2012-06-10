//
//  FaceView.m
//  Happiness
//
//  Created by Jais Cheema on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize scale = _scale;

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) awakeFromNib
{
    [self setup];
}

#define DEFAULT_SCALE 0.90

- (CGFloat) scale
{
    if(!_scale)
    {
        return DEFAULT_SCALE;
    }
    else {
        return _scale;
    }
}

- (void) setScale:(CGFloat)scale
{
    if( scale != _scale )
    {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void) pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius inContext:(CGContextRef)context 
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

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
    radius = self.scale * radius;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];

    [self drawCircleAtPoint:midPoint withRadius:radius inContext:context];
    
#define EYE_H  0.35
#define EYE_V  0.35
#define EYE_RADIUS  0.10
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - radius * EYE_H;
    eyePoint.y = midPoint.y - radius * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:radius * EYE_RADIUS inContext:context];
    eyePoint.x += radius * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:radius * EYE_RADIUS inContext:context];
    
#define MOUTH_H 0.45
#define MOUTH_V 0.45
#define MOUTH_SMILE 0.25

    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * radius;
    mouthStart.y = midPoint.y + MOUTH_V * radius;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * radius * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * radius * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * radius * 2/3;
    
    float smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * radius * smile;
    
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}


@end
