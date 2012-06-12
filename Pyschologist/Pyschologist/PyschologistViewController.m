//
//  PyschologistViewController.m
//  Pyschologist
//
//  Created by Jais Cheema on 11/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PyschologistViewController.h"
#import "HappinessViewController.h"

@interface PyschologistViewController()
@property (nonatomic) int diagnosis;
@end

@implementation PyschologistViewController

@synthesize diagnosis = _diagnosis;

- (void) setDiagnosis:(int)diagnosis
{
    if(diagnosis > 100) diagnosis = 100;
    if(diagnosis < 0) diagnosis = 0;
    _diagnosis = diagnosis;
}

- (void) setAndShowDiagnosis:(int)diagnosis
{
    self.diagnosis = diagnosis;
    [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowDiagnosis"] )
    {
        [segue.destinationViewController setHappiness:self.diagnosis];
    }
    else if([segue.identifier isEqualToString:@"Serious"])
    {
        [segue.destinationViewController setHappiness:20.0];
    }
    else if([segue.identifier isEqualToString:@"TV Kook"])
    {
        [segue.destinationViewController setHappiness:50.0];
    }
    else if([segue.identifier isEqualToString:@"Celebrity"])
    {
        [segue.destinationViewController setHappiness:100];
    }

}

- (IBAction)flying 
{
    [self setAndShowDiagnosis:85];
}

- (IBAction)chased:(id)sender 
{
    [self setAndShowDiagnosis:15];
}

- (IBAction)investigating 
{
    [self setAndShowDiagnosis:55];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
