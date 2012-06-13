//
//  RotatingViewController.m
//  Calculator
//
//  Created by Jais Cheema on 13/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "RotatingViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@implementation RotatingViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
{
    id detailView = [self.splitViewController.viewControllers lastObject];
    if (![detailView conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailView = nil;
    }
     return detailView;
}

- (BOOL) splitViewController:(UISplitViewController *)svc 
    shouldHideViewController:(UIViewController *)vc 
               inOrientation:(UIInterfaceOrientation)orientation
{
    if([self splitViewBarButtonItemPresenter])
    {
        return UIInterfaceOrientationIsPortrait(orientation);
    }
    else
    {
        return NO;
    }
} 
- (void) splitViewController:(UISplitViewController *)svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButton = barButtonItem;
}

- (void) splitViewController:(UISplitViewController *)svc 
      willShowViewController:(UIViewController *)aViewController 
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
