//
//  HappinessViewController.m
//  Happiness
//
//  Created by Jais Cheema on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

@interface HappinessViewController() <FaceViewDataSource>

@property (nonatomic,weak) IBOutlet  FaceView *faceView;

@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

-(void) handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView]; 
    }
}

-(void) setFaceView:(FaceView *)faceView
{
    _faceView = faceView;
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    self.faceView.dataSource = self;
}

- (float) smileForFaceView:(FaceView *)faceView
{
    return ( self.happiness - 50 ) / 50.0;
}

- (void) setHappiness:(int)happiness
{
    if(happiness > 100) happiness = 100;
    if(happiness < 0 ) happiness = 0;
    if(happiness != _happiness)
    {
        _happiness = happiness;
        [self.faceView setNeedsDisplay];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
