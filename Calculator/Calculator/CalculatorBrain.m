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

- (double) performOperation:(NSString *)operation withVariableValues:(NSDictionary *)variableValues
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

+ (NSString *) formatDescription:(id)object
{
    NSString *description;
    if ([object isKindOfClass:[NSString class]]) {
        description = [NSString stringWithFormat:@"( %@ )",object];
    }
    else {
        description = [object description];
    }
    return description;
}

+ (id) popOperandForDescription:(NSMutableArray *)stack
{
    id description;
    NSArray *operations = [[NSArray alloc] initWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt", nil];
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]])
    {
        description = topOfStack;
    }
    else if([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operations containsObject:operation]) {
            if([operation isEqualToString:@"+"])
            {
                id obj = [self popOperandForDescription:stack];
                description = [NSString stringWithFormat:@" %@ + %@ ",[self popOperandForDescription:stack], obj];
            }
            else if([operation isEqualToString:@"-"])
            {
                id obj = [self popOperandForDescription:stack];
                description = [NSString stringWithFormat:@" %@ - %@ ",[self popOperandForDescription:stack], obj];
            }
            else if([operation isEqualToString:@"*"])
            {
                id obj = [self popOperandForDescription:stack];
                description = [NSString stringWithFormat:@" %@ * %@ ",[self formatDescription:[self popOperandForDescription:stack]], [self formatDescription:obj]];
            }
            else if([operation isEqualToString:@"/"])
            {
                id obj = [self popOperandForDescription:stack];
                description = [NSString stringWithFormat:@" %@ / %@ ",[self formatDescription:[self popOperandForDescription:stack]], [self formatDescription:obj]];
            }
            else if([operation isEqualToString:@"sin"])
            {
                description = [NSString stringWithFormat:@" sin %@ ",[self formatDescription:[self popOperandForDescription:stack]]];
            }
            else if([operation isEqualToString:@"cos"])
            {
                description = [NSString stringWithFormat:@" cos %@ ",[self formatDescription:[self popOperandForDescription:stack]]];
            }
            else if([operation isEqualToString:@"sqrt"])
            {
                description = [NSString stringWithFormat:@" sqrt %@ ",[self formatDescription:[self popOperandForDescription:stack]]];
            }
            else {
                description = @"undef";
            }
        }
        else {
            description = operation;
        }
    }
    else {
        description = [NSNumber numberWithDouble:0.0];
    }
    return description;
}

+ (NSString *) descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }

    return [[self popOperandForDescription:stack] description];
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

+ (NSMutableArray *) substitutedProgram:(id)program withVariableValues:(NSDictionary *)variableValues
{
    NSArray *programAsArray;
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSSet *variablesInProgram;
    if ([program isKindOfClass:[NSArray class]])
    {
        programAsArray = program;
    }
    variablesInProgram = [self variablesUsedInProgram:program];
    if(variablesInProgram == nil)
    {
        return [programAsArray mutableCopy];
    }
    else {
        for(id operand in programAsArray)
        {
            if([operand isKindOfClass:[NSString class]])
            {
                if([variablesInProgram containsObject:operand])
                {
                    NSString *key = operand;
                    double substitutionValue = 0;
                    id value = [variableValues objectForKey:key];
                    if ([value isKindOfClass:[NSNumber class]])
                    {
                        substitutionValue = [value doubleValue];
                    }
                    [stack addObject:[NSNumber numberWithDouble:substitutionValue]];
                }
                else {
                    [stack addObject:operand];
                }
            }
            else {
                [stack addObject:operand];
            }
        }
        return [stack mutableCopy];
    }
}

+ (double) runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack = [self substitutedProgram:program withVariableValues:variableValues];
    return [self popOperandOffStack:stack];
}

+ (NSSet *) variablesUsedInProgram:(id)program
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    NSArray *operations = [[NSArray alloc] initWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt",@"π", nil];
    
    if([program isKindOfClass:[NSArray class]])
    {
        NSArray *stack = program;
        for(id obj in stack)
        {
            if([obj isKindOfClass:[NSString class]])
            {
                NSString *item = obj;
                if(![operations containsObject:item])
                {
                    [variables addObject:item];
                }
            }
        }
    }
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
    self.programStack = nil;
}

@end
