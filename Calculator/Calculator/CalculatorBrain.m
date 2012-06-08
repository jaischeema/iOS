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

@property (nonatomic,strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (id) program
{
    return [self.programStack copy];
}

- (NSMutableArray *) programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void) pushOperand:(double)operand
{ 
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"Description of the program";
}

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue]; 
    }
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) 
        {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffStack:stack];
            if(divisor == 0)
            {
                result = 0;
            }
            else {
                result = [self popOperandOffStack:stack] / divisor;
            }
        }
        else if ([operation isEqualToString:@"-"])
        {
            double subtractor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtractor;
        }
        else if([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"sqrt"])
        {
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"π"])
        {
            result = M_PI;
        }
        else {
            result = 0.0;
        }
    }
    return result;
}

+ (double) runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    return [self runProgram:program];
}

+ (NSSet *) variablesUsedInProgram:(id)program
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if(variables.count == 0)
    {
        return nil;
    }
    else{
        return [variables copy];
    }
}

- (void) clear
{
    self.programStack = [[NSMutableArray alloc] init];
}

@end
