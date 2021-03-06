//
//  PlacesTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 20/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PlaceImagesTableViewController.h"
#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface PlacesTableViewController ()
@end

@implementation PlacesTableViewController
@synthesize topPlaces = _topPlaces;

- (NSArray *)annotationsForMap
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for(NSDictionary *place in self.topPlaces)
    {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:place]];
    }
    return annotations;
}

- (void) updateSplitView
{    
    UINavigationController *detailNavigationController = [self.splitViewController.viewControllers lastObject];
    id mvc = [detailNavigationController.viewControllers objectAtIndex:0];
    if([mvc isKindOfClass:[MapViewController class]])
    {
        [mvc setAnnotations:[self annotationsForMap]];
    }
}

- (void) setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces != topPlaces)
    {
        _topPlaces = topPlaces;
        [self updateSplitView];
        [self.tableView reloadData];
    }
}

- (IBAction)refresh:(id)sender 
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places", NULL);
    dispatch_async(downloadQueue, ^{
        NSMutableArray *places = [[FlickrFetcher topPlaces] mutableCopy];
        [places sortUsingComparator: ^NSComparisonResult(id obj1, id obj2) {            
            return [[obj1 objectForKey:FLICKR_PLACE_NAME]  compare:[obj2 objectForKey:FLICKR_PLACE_NAME]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.leftBarButtonItem = sender;
            self.topPlaces = places;
        });
    });
    dispatch_release(downloadQueue);
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


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    id obj = [self.topPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrFetcher titleForPlace:obj];
    cell.detailTextLabel.text = [FlickrFetcher subtitleForPlace:obj];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Images for Place"])
    {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        dispatch_queue_t imageQueue = dispatch_queue_create("flickr image list", NULL);
        dispatch_async(imageQueue, ^{
            NSArray *photos = [FlickrFetcher photosInPlace:[self.topPlaces objectAtIndex:path.row] maxResults:20];
            dispatch_async(dispatch_get_main_queue(), ^{
                [segue.destinationViewController setImages:photos];
            });
        });
        dispatch_release(imageQueue);
    }
    else if([segue.identifier isEqualToString:@"ShowPlacesMap"])
    {
        [segue.destinationViewController setAnnotations:[self annotationsForMap]];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
