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
#import "MapViewController.h"

@interface ImageTableViewController ()
@end

@implementation ImageTableViewController

@synthesize images = _images;

- (void) setupMap
{
    UIBarButtonItem *mapButton;
    if(self.navigationController.splitViewController)
    {
        mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapForPad:)];
    }
    else {
        mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapForPhone:)];
    }
    self.navigationItem.rightBarButtonItem = mapButton;
}

- (void) setImages:(NSArray *)images
{
    if( _images != images )
    {
        _images = images;
        [self setupMap];
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

- (void) showMapForPhone:(id)sender
{
    [self performSegueWithIdentifier:@"ShowImagesMap" sender:self];
}

- (void) showMapForPad:(id)sender
{
    // do something like replacing the detail view controller
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
    cell.textLabel.text = [FlickrFetcher titleForImage:obj];//[self titleForImage:obj];
    cell.detailTextLabel.text = [FlickrFetcher subtitleForImage:obj];//[self descriptionForImage:obj];
    return cell;
}

- (NSArray *) annotationsForMap
{
    return nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowImagesMap"])
    {
        [segue.destinationViewController setAnnotations:[self annotationsForMap]];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
