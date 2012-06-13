//
//  GraphView.m
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@end

@implementation GraphView

@synthesize delegate = _delegate;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (CGFloat) scale
{
    if(!_scale) {
        return 1.0;
    }
    else {
        return _scale;
    }
}

- (void) setScale:(CGFloat)scale
{
    if(_scale != scale)
    {
        _scale = scale;
        [self setNeedsDisplay];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if(standardUserDefaults) 
        {
            [standardUserDefaults setDouble:scale forKey:@"scale"];
        }
    }
}

- (void) setOrigin:(CGPoint)origin
{
    if( origin.x != _origin.x || origin.y != origin.y)
    {
        _origin = origin;
        [self setNeedsDisplay];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if(standardUserDefaults) 
        {
            [standardUserDefaults setDouble:origin.x forKey:@"origin_x"];
            [standardUserDefaults setDouble:origin.y forKey:@"origin_y"];
        }
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if(standardUserDefaults) 
    {
        double x = [standardUserDefaults doubleForKey:@"origin_x"];
        double y = [standardUserDefaults doubleForKey:@"origin_y"];
        if( x && y )
        {
            self.origin = CGPointMake(x,y);
        }
        else {
            self.origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        }
        self.scale = [standardUserDefaults doubleForKey:@"scale"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setup];
}

- (CGPoint) pointFor:(CGFloat)x
{
    return CGPointMake(self.origin.x + ( x * self.scale ), self.origin.y - ( self.scale * [self.delegate valueOfGraphAt:x]));
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];

    // Calculate the minimum x value in points
    CGFloat minX = ( self.origin.x - (self.origin.x * 2) ) / self.scale;
    
    // Calculate the maximum x value in points
    CGFloat maxX = ( self.bounds.size.width - self.origin.x ) / self.scale;
    
    // Calculate the number of pixels per point
    CGFloat ppp = 1 / ( self.contentScaleFactor * self.scale);
    
    CGContextBeginPath(context);
    CGPoint startingPoint = [self pointFor:minX];
    CGContextMoveToPoint(context, startingPoint.x, startingPoint.y);
    // go from min x to max x incrementing by (point/pixelperpoint) ( 1/3 = 0.33 )
    for(double i = minX; i <= maxX; i += ppp)
    {
        CGPoint currentPoint = [self pointFor:i];
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    CGContextStrokePath(context);
    // draw the point then
}


/* Gesture recognisers */
- (void) pinch:(UIPinchGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }

}

- (void) pan:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translation = [gesture translationInView:self];
        CGPoint newOrigin = CGPointMake(self.origin.x + translation.x, self.origin.y + self.origin.y);
        self.origin = newOrigin;
    }

}

- (void) threeTaps:(UITapGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.origin = [gesture locationInView:self];
    }
}

@end
