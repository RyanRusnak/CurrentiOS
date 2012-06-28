//
//  TabBarController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "SplashViewController.h"

@interface TabBarController : UITabBarController{
    
    BOOL presentedLogin;
}

-(void) notifyMaster;

@end
