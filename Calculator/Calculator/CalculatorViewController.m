//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jais Cheema on 5/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@property (nonatomic,strong) NSMutableDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize pointButton = _pointButton;
@synthesize descriptionDisplay = _descriptionDisplay;
@synthesize variableValueDisplay = _variableValueDisplay;
@synthesize userIsInTheMiddleOfTypingANumber = _userIsInTheMiddleOfTypingANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *) brain
{
    if( _brain == nil ) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSMutableDictionary *) testVariableValues
{
    if(_testVariableValues == nil) _testVariableValues = [[NSMutableDictionary alloc] init];
    return _testVariableValues;
}

- (void) updateDisplay
{
    // Update the logic to update all the screen elements here instead of doing it every method
}

- (IBAction)digitPressed:(UIButton * )sender 
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfTypingANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (void) updateHistoryLabel:(NSString *)addedText
{
    self.descriptionDisplay.text = 
        [self.descriptionDisplay.text stringByAppendingFormat:@"%@ ", addedText];
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTypingANumber = NO;
    self.pointButton.enabled = YES;
    [self updateHistoryLabel:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTypingANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle withVariableValues:self.testVariableValues];
    [self updateHistoryLabel:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g ",result];
}

- (IBAction)pointPressed
{
    if (self.userIsInTheMiddleOfTypingANumber) {
        
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
    else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfTypingANumber = YES;
    }
    self.pointButton.enabled = NO;
}

- (IBAction)clearPressed 
{
    [self.brain clear];
    self.display.text = @"0";
    self.descriptionDisplay.text = @"";
    self.testVariableValues = nil;
    self.userIsInTheMiddleOfTypingANumber = NO;
    [self updateVariableDisplay];
}

- (void) updateVariableDisplay
{
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSMutableString *displayText = [[NSMutableString alloc] init];
    for(id variable in variables)
    {
        if([variable isKindOfClass:[NSString class]])
        {
            id obj = [self.testVariableValues objectForKey:variable];
            double value = 0; 
            if ([obj isKindOfClass:[NSNumber class]]) {
                value = [obj doubleValue];
            }
            [displayText appendFormat:@"%@ = %g   ",variable, value];
        }
    }
    self.variableValueDisplay.text = displayText;
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    [self.brain pushVariable:sender.currentTitle];
    [self enterPressed];
    [self updateVariableDisplay];
}

- (IBAction)undoPressed 
{
}

- (IBAction)testPressed:(UIButton *)sender 
{
    NSString *title = [sender currentTitle];
    if([title isEqualToString:@"Test 1"])
    {
        [self.testVariableValues setObject:[NSNumber numberWithInt:1] forKey:@"x"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:10] forKey:@"a"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:20] forKey:@"b"];
    }
    else if([title isEqualToString:@"Test 2"])
    {
        [self.testVariableValues setObject:[NSNumber numberWithInt:100] forKey:@"x"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:20] forKey:@"a"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:-10] forKey:@"b"];
    }
    else if([title isEqualToString:@"Test 3"])
    {
        [self.testVariableValues setObject:[NSNumber numberWithInt:0] forKey:@"x"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:-200] forKey:@"a"];
        [self.testVariableValues setObject:[NSNumber numberWithInt:-1000] forKey:@"b"];
    }
    [self updateVariableDisplay];
}

@end
