//
//  AskerViewController.m
//  Kitchen Sink
//
//  Created by Jais Cheema on 25/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "AskerViewController.h"

@interface AskerViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@end

@implementation AskerViewController
@synthesize questionLabel = _questionLabel;
@synthesize answerTextField = _answerTextField;
@synthesize question = _question;
@synthesize answer = _answer;

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.answerTextField.delegate = self;
}

- (void) setQuestion:(NSString *)question
{
    _question = question;
    self.questionLabel.text = question;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.answerTextField becomeFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.answer = textField.text;
    if(![textField.text length])
    {
        [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    }
    else {
         
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text length])
    {
        [textField resignFirstResponder];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setQuestionLabel:nil];
    [self setAnswerTextField:nil];
    [super viewDidUnload];
}

@end
