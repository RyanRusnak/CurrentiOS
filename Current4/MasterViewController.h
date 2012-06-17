//
//  MasterViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "Device.h"
#import "AppDelegate.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
	NSMutableArray *devices;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
