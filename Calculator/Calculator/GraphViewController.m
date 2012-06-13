//
//  GraphViewController.m
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController () <GraphViewDataSource>
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;

- (void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.delegate = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(threeTaps:)];
    tapGesture.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGesture];
}

- (CGFloat)valueOfGraphAt:(CGFloat)x;
{
    return ( x * x ) / 30;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
