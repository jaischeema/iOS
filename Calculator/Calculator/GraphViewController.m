//
//  GraphViewController.m
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "CalculatorProgramsTableViewController.h"

@interface GraphViewController () <GraphViewDataSource>
@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel *expressionDisplay;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize toolbar = _toolbar;
@synthesize expressionDisplay = _expressionDisplay;
@synthesize program = _program;
@synthesize splitViewBarButton = _splitViewBarButton;
 
- (void) setSplitViewBarButton:(UIBarButtonItem *)splitViewBarButton
{
    if(_splitViewBarButton != splitViewBarButton)
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if( _splitViewBarButton ) [toolbarItems removeObject:_splitViewBarButton];
        if(splitViewBarButton) [toolbarItems insertObject:splitViewBarButton atIndex:0];
        _splitViewBarButton = splitViewBarButton;
        self.toolbar.items = toolbarItems;
    }
}
- (void) viewDidLoad
{
    self.expressionDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
}

- (void) setProgram:(id)program
{
    _program = program;
    self.expressionDisplay.text = [CalculatorBrain descriptionOfProgram:self.program];
    [self.graphView setNeedsDisplay];
}

- (void) setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    self.graphView.delegate = self;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    //[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(threeTaps:)];
    tapGesture.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGesture];
    NSLog(@"This works");
}

- (CGFloat)valueOfGraphAt:(CGFloat)x;
{
    NSDictionary *values = 
        [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:x] forKey:@"x"];
    return [CalculatorBrain runProgram:self.program usingVariableValues:values];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setToolbar:nil];
    [super viewDidUnload];
}

#define FAVOURITES_KEY @"GraphViewController.Favourites"

- (IBAction)addToFavourites 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favourites = [[defaults objectForKey:FAVOURITES_KEY] mutableCopy] ;
    if(!favourites) favourites = [[NSMutableArray alloc] init]; 
    [favourites addObject:self.program];
    [defaults setObject:favourites forKey:FAVOURITES_KEY];
    [defaults synchronize];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFavourites"])
    {
        [(CalculatorProgramsTableViewController *)(segue.destinationViewController) setPrograms:[[NSUserDefaults standardUserDefaults] objectForKey:FAVOURITES_KEY]];
    }
}

@end
