//
//  GraphView.h
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDelegate
- (CGFloat)valueOfYCoordinateFor:(CGFloat)x;
@end

@interface GraphView : UIView

@property (nonatomic, weak) id <GraphViewDelegate> delegate;
@end
