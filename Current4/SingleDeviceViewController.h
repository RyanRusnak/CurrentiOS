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

@interface SingleDeviceViewController : UITableViewController <UITextFieldDelegate>
{

}

@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) NSMutableArray *singleDeviceArray;
//@property (strong, nonatomic) Device *my_device;
@property (strong, nonatomic) NSIndexPath *rowID;
@property (strong, nonatomic) UITextField *myTextField;
@property (assign) NSUInteger row;
@property (assign) int rowClicked;


@end
