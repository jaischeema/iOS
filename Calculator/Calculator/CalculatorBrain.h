//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jais Cheema on 5/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

- (void) pushOperand:(double)operand;
- (void) pushVariable:(NSString *)variable;
- (double) performOperation:(NSString *)operation withVariableValues:(NSDictionary *)variableValues;
- (void) clear;

+ (double) runProgram:(id)program;
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *) variablesUsedInProgram:(id)program;
+ (NSString *) descriptionOfProgram:(id)program;

@end
