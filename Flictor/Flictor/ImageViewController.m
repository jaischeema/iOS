//
//  ImageViewController.m
//  Flictor
//
//  Created by Jais Cheema on 17/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize spinner = _spinner;
@synthesize image = _image;


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void) setImage:(UIImage *)image
{
    if(_image != image)
    {
        _image = image;
        [self.spinner stopAnimating];
        self.imageView.image = self.image;
        self.scrollView.contentSize = self.image.size;
        self.imageView.frame = CGRectMake(0,0,self.image.size.width,self.image.size.height);
        [self.scrollView setNeedsDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.spinner startAnimating];
    self.scrollView.delegate = self;
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    self.image = nil;
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
