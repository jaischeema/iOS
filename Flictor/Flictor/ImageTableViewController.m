//
//  ImageTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 16/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "ImageTableViewController.h"
#import "FlickrFetcher.h"

@interface ImageTableViewController ()

@end

@implementation ImageTableViewController

@synthesize images = _images;

- (void) setImages:(NSArray *)images
{
    if( _images != images )
    {
        _images = images;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#define UKNOWN @"Unknown"


- (NSString *) descriptionForImage:(NSDictionary *)image
{
    NSArray *keys = [FLICKR_PHOTO_DESCRIPTION componentsSeparatedByString:@"."];
    NSString *description = [[image objectForKey:[keys objectAtIndex:0]] objectForKey:[keys lastObject]];
    if(!description || [description isEqualToString:@""])
    {
        description = nil;
    }
    return description;
}

- (NSString *) titleForImage:(NSDictionary *)image
{
    id titleObj = [image objectForKey:FLICKR_PHOTO_TITLE];
    NSString *title;
    if (titleObj) {
        if([titleObj isKindOfClass:[NSString class]])
        {
            if([titleObj isEqualToString:@""])
            {
                NSString *description = [self descriptionForImage:image];
                if(description)
                {
                    title = description;
                }
                else {
                    title = UKNOWN;
                }
            }
            else {
                title = (NSString *)titleObj;
            }
        }
        else if ([titleObj isKindOfClass:[NSNumber class]]) {
            title = [NSString stringWithFormat:@"%g",titleObj];
        }
    }
    else {
        NSString *description = [self descriptionForImage:image];
        if(description)
        {
            title = description;
        }
        else {
            title = UKNOWN;
        }
    }
    return title;
}

#define RECENT_IMAGES @"Flictor.ImageViewController.Recent"

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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.images count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Image";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id obj = [self.images objectAtIndex:indexPath.row];
    cell.textLabel.text = [self titleForImage:obj];
    cell.detailTextLabel.text = [self descriptionForImage:obj];
    return cell;
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
        [self addToRecentlyViewedItems:imageObj];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
