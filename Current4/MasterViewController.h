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
#import "Canvas.h"
#import "SingleDeviceViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
	NSMutableArray *devices;
    BOOL refreshClicked;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) SingleDeviceViewController *singleDeviceViewController;

-(void) showDevices;
- (void)refreshData:(NSNotification *)notification;

@end
