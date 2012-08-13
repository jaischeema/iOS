//
//  KitchenSinkViewController.m
//  Kitchen Sink
//
//  Created by Jais Cheema on 25/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "KitchenSinkViewController.h"

@interface KitchenSinkViewController ()
@property (weak, nonatomic) IBOutlet UIView *kitchenSink;

@end

@implementation KitchenSinkViewController
@synthesize kitchenSink;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setKitchenSink:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
