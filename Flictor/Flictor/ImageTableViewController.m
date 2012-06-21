//
//  ImageTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 16/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "ImageTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface ImageTableViewController ()
@end

@implementation ImageTableViewController

@synthesize images = _images;

- (void) setImages:(NSArray *)images
{
    if( _images != images )
    {
        _images = images;
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMap:)];
        self.navigationItem.rightBarButtonItem = mapButton;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void) showMap:(id)sender
{
    NSLog(@"Showing Map");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#define UKNOWN @"Unknown"


- (NSString *) descriptionForImage:(NSDictionary *)image
{
    NSString *description = [image valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]; 
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
