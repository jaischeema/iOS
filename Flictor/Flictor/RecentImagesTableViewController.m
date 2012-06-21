//
//  RecentImagesTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 20/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "RecentImagesTableViewController.h"
#import "FlickrFetcher.h"

@interface RecentImagesTableViewController() <UITabBarControllerDelegate>
@end

@implementation RecentImagesTableViewController

- (IBAction)clear:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSArray alloc] init] forKey:RECENT_IMAGES];
    [defaults synchronize];
    self.images = nil;
}

- (void) loadImages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentImages = [defaults arrayForKey:RECENT_IMAGES];
    if(!recentImages)
    {
        recentImages = [[NSArray alloc] init];
    }
    NSLog(@"%d",[recentImages count]);
    self.images = recentImages;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    if(self.navigationController.splitViewController)
    {
        self.navigationController.splitViewController.tabBarController.delegate = self;
    }
    else {
        self.navigationController.tabBarController.delegate = self;
    }
    [self loadImages];
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if(viewController == self.navigationController)
    {
        [self loadImages];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Image"])
    {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        NSDictionary *imageObj = [self.images objectAtIndex:path.row];
        dispatch_queue_t imageQueue = dispatch_queue_create("flickr image download", NULL);
        dispatch_async(imageQueue, ^{
            NSURL *url = [FlickrFetcher urlForPhoto:imageObj format:FlickrPhotoFormatLarge];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [segue.destinationViewController setImage:image];
                [segue.destinationViewController setTitle:[self titleForImage:imageObj]];
            });
        });
        dispatch_release(imageQueue);
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
