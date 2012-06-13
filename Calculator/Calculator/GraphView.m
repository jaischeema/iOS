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
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
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
    }
}

- (void) setOrigin:(CGPoint)origin
{
    if( origin.x != _origin.x || origin.y != origin.y)
    {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
    _origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
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

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
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

- (void) tap:(UITapGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)
    {
        self.origin = [gesture locationInView:self];
    }
}

@end
