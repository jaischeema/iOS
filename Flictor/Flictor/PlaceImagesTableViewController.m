//
//  PlaceImagesTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 20/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "PlaceImagesTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@implementation PlaceImagesTableViewController

- (void) addToRecentlyViewedItems:(NSDictionary *)image
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults arrayForKey:RECENT_IMAGES] mutableCopy];
    if(!recents)
    {
        recents = [[NSMutableArray alloc] init];
    }
    BOOL alreadyThere = NO;
    for(NSDictionary *obj in recents)
    {
        if([[obj objectForKey:FLICKR_PHOTO_ID] isEqualToString:[image objectForKey:FLICKR_PHOTO_ID]])
        {
            alreadyThere = YES;
            break;
        }
    }
    if(!alreadyThere)
    {
        [recents addObject:image];
    }
    [defaults setObject:[recents copy] forKey:RECENT_IMAGES];
    [defaults synchronize];
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
                [segue.destinationViewController setTitle:[FlickrFetcher titleForImage:imageObj]];
            });
        });
        dispatch_release(imageQueue);
        [self addToRecentlyViewedItems:imageObj];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.navigationController.splitViewController)
    {
        id ivc = [self.navigationController.splitViewController.viewControllers lastObject];
        if([ivc isKindOfClass:[ImageViewController class]])
        {
            NSDictionary *imageObj = [self.images objectAtIndex:indexPath.row];
            dispatch_queue_t imageQueue = dispatch_queue_create("flickr image download", NULL);
            dispatch_async(imageQueue, ^{
                NSURL *url = [FlickrFetcher urlForPhoto:imageObj format:FlickrPhotoFormatLarge];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ivc setImage:image];
                    [ivc setTitle:[FlickrFetcher titleForImage:imageObj]];
                });
            });
            dispatch_release(imageQueue);
            [self addToRecentlyViewedItems:imageObj];
        }
    }
}

@end
