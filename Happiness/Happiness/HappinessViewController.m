//
//  HappinessViewController.m
//  Happiness
//
//  Created by Jais Cheema on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

@interface HappinessViewController()

@property (nonatomic,weak) IBOutlet  FaceView *faceView;

@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

-(void) setFaceView:(FaceView *)faceView
{
    _faceView = faceView;
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)];
    [self.faceView addGestureRecognizer:gesture];
}

- (void) setHappiness:(int)happiness
{ 
    if(happiness > 100) happiness = 100;
    if(happiness < 0 ) happiness = 0;
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
