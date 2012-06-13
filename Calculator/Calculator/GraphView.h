//
//  GraphView.h
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource
- (CGFloat)valueOfGraphAt:(CGFloat)y;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) id <GraphViewDataSource> delegate;

- (void) pinch:(UIPinchGestureRecognizer *)gesture;
- (void) pan:(UIPanGestureRecognizer *)gesture;
- (void) threeTaps:(UITapGestureRecognizer *)gesture;

@end
