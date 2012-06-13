//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Jais Cheema on 5/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize pointButton = _pointButton;
@synthesize descriptionDisplay = _descriptionDisplay;
@synthesize userIsInTheMiddleOfTypingANumber = _userIsInTheMiddleOfTypingANumber;
@synthesize brain = _brain;

- (void) viewDidLoad
{
    self.title = @"Calculator";
}

- (CalculatorBrain *) brain
{
    if( _brain == nil ) _brain = [[CalculatorBrain alloc] init];
    return _brain;
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

- (IBAction)graphPressed 
{
    id gvc = [self.splitViewController.childViewControllers lastObject];
    if(![gvc isKindOfClass:[GraphViewController class]])
    {
        gvc = nil;
    }
    if(gvc)
    {
        GraphViewController *graph = (GraphViewController *) gvc;
        graph.program = self.brain.program;
    }
}

- (void) updateHistoryLabel:(NSString *)addedText
{
    self.descriptionDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        //[self.descriptionDisplay.text stringByAppendingFormat:@"%@ ", addedText];
}

- (IBAction)enterPressed 
{
    if(self.userIsInTheMiddleOfTypingANumber)
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.userIsInTheMiddleOfTypingANumber = NO;
    self.pointButton.enabled = YES;
    [self updateHistoryLabel:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfTypingANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle withVariableValues:nil];
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
    self.userIsInTheMiddleOfTypingANumber = NO;
}


- (IBAction)variablePressed:(UIButton *)sender 
{
    [self.brain pushVariable:sender.currentTitle];
    [self enterPressed];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Graph"])
    {
        [segue.destinationViewController setProgram:self.brain.program];
    }
}

@end
