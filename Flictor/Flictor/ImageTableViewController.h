//
//  ImageTableViewController.h
//  Flictor
//
//  Created by Jais Cheema on 16/06/12.
//  Copyright (c) 2012 Allmark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RECENT_IMAGES @"Flictor.ImageViewController.Recent"

@interface ImageTableViewController : UITableViewController
@property (nonatomic,strong) NSArray *images;

- (NSString *) titleForImage:(NSDictionary *)image;
- (NSString *) descriptionForImage:(NSDictionary *)image;

@end
