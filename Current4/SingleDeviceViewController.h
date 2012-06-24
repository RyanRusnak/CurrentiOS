//
//  SingleDeviceViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Device.h"

@interface SingleDeviceViewController : UITableViewController
{

}

@property (strong, nonatomic) NSMutableArray *singleDeviceArray;
@property (strong, nonatomic) NSIndexPath *rowID;


@end
