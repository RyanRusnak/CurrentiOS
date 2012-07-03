//
//  TabBarController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleDeviceViewController.h"


@interface TabBarController : UITabBarController{
    
    BOOL presentedLogin;
}

@property (strong, nonatomic) SingleDeviceViewController *singleDeviceViewController;
@property (strong, nonatomic) NSIndexPath *rowIndex;

-(void) notifyMaster;

@end
