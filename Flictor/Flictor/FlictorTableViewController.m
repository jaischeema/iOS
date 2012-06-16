//
//  FlictorTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 16/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "FlictorTableViewController.h"
#import "FlickrFetcher.h"

@interface FlictorTableViewController ()

@end

@implementation FlictorTableViewController

@synthesize topPlaces = _topPlaces;

- (void) setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces != topPlaces)
    {
        _topPlaces = topPlaces;
        [self.tableView reloadData];
    }
}

- (IBAction)refresh:(id)sender 
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *places = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
