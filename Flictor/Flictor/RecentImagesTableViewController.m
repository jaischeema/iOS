//
//  RecentImagesTableViewController.m
//  Flictor
//
//  Created by Jais Cheema on 20/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import "RecentImagesTableViewController.h"

@implementation RecentImagesTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.images = [defaults arrayForKey:RECENT_IMAGES];
}

@end
