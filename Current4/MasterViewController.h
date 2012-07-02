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
#import "TabBarController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController
{
	NSMutableArray *devices;
    BOOL refreshClicked;
    UITableView *tableView1;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) SingleDeviceViewController *singleDeviceViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

-(void) showDevices;
- (void)refreshData:(NSNotification *)notification;
-(void)callUpdateRotation;
-(void)drillInMaster;
- (void)callDrillInMaster:(NSNotification *)notification;

@end
