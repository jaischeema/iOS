//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jais Cheema on 5/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()

@property (nonatomic,strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *) operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (void) pushOperand:(double)operand
{ 
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) popOperand
{
    NSNumber *operandObject =  [self.operandStack lastObject]; 
    if (operandObject) [self.operandStack removeLastObject]; 
    return [operandObject doubleValue];
}

- (double) performOperation:(NSString *)operation
{
    double result = 0;
    if ([operation isEqualToString:@"+"]) 
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    }
    else if ([operation isEqualToString:@"/"])
    {
        double value1 = [self popOperand];
        double value2 = [self popOperand];
        if(value1 == 0)
        {
            result = 0;
        }
        else {
             result = value2 / value1;
        }
    }
    else if ([operation isEqualToString:@"-"])
    {
        double value1 = [self popOperand];
        double value2 = [self popOperand];
        result = value2 - value1;
    }
    else if([operation isEqualToString:@"sin"])
    {
        result = sin([self popOperand]);
    }
    else if([operation isEqualToString:@"cos"])
    {
        result = cos([self popOperand]);
    }
    else if([operation isEqualToString:@"sqrt"])
    {
        result = sqrt([self popOperand]);
    }
    else if([operation isEqualToString:@"π"])
    {
        result = M_PI;
    }
    else {
        result = 0.0;
    }
    [self pushOperand:result]; 
    return result;
}

- (void) clear
{
    self.operandStack = [[NSMutableArray alloc] init];
}

@end
