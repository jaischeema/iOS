//
//  GraphView.m
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

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

- (void) awakeFromNib
{
    [self setup];
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:center scale:1.0];
}


@end
