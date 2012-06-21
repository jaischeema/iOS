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
#import "ImageMapViewController.h"
#import "FlickrAnnotation.h"

@interface PlacesTableViewController ()
@end

@implementation PlacesTableViewController
@synthesize topPlaces = _topPlaces;

- (NSArray *)annotationsForMap
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for(NSDictionary *place in self.topPlaces)
    {
        [annotations addObject:[FlickrAnnotation annotationForPhoto:place]];
    }
    return annotations;
}

- (void) updateSplitView
{
    id detail = [self.navigationController.splitViewController.viewControllers lastObject];
    if([detail isKindOfClass:[ImageMapViewController class]])
    {
        [detail setAnnotations:[self annotationsForMap]];
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
            self.topPlaces = [places copy];
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


#pragma mark Custom Methods

- (NSString *) titleFor:(NSString *)description
{
    NSArray *chunks = [description componentsSeparatedByString:@","];
    return [chunks objectAtIndex:0];
}

- (NSString *) subtitleFor:(NSString *)description
{
    NSMutableArray *chunks = [[description componentsSeparatedByString:@","] mutableCopy];
    [chunks removeObjectAtIndex:0];
    NSString * firstString = [chunks objectAtIndex:0];
    [chunks replaceObjectAtIndex:0 withObject:[firstString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return [chunks componentsJoinedByString:@","];
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
    cell.textLabel.text = [self titleFor:[obj objectForKey:FLICKR_PLACE_NAME]];
    cell.detailTextLabel.text = [self subtitleFor:[obj objectForKey:FLICKR_PLACE_NAME]];
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
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
