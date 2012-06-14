//
//  ImaginariumViewController.m
//  Imaginarium
//
//  Created by Jais Cheema on 14/06/12.
//  Copyright (c) 2012 CyberSecure. All rights reserved.
//

#import "ImaginariumViewController.h"

@interface ImaginariumViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImaginariumViewController
@synthesize scrollView;
@synthesize imageView;

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.delegate = self;
    self.imageView.frame = CGRectMake(0,0,self.imageView.image.size.width,self.imageView.image.size.height);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload]; 
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
