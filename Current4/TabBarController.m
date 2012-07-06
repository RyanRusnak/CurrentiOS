//
//  TabBarController.m
//  Current4
//
//  Created by Ryan Rusnak on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize singleDeviceViewController;
@synthesize rowIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    if(presentedLogin != YES){
//    //[self performSegueWithIdentifier: @"presentSplash" sender: self];
//        presentedLogin = YES;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Add refresh button
//	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
//																			 target:self 
//																			 action:@selector(notifyMaster)];
//    self.navigationItem.leftBarButtonItem = refresh;

//    [self.view insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbar-bg-r.png"]]  atIndex:0];
//    if ([self.view respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
//        [self.view setBackgroundImage:[UIImage imageNamed:@"headbar-bg-r.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    } else {
//        [self.view insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbar-bg-r.png"]] atIndex:0];
//    }
    
    //[self.tabBarController setBackgroundImage:[UIImage imageNamed:@"imageName.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    

//    UIImageView *backgroundImage =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headbar-bg-r.png"]];
//    [self.tabBarController.tabBar insertSubview:backgroundImage atIndex:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRotation"
                                                            object:nil];
        return YES;
    }
}

-(void) notifyMaster
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData"
                                                        object:nil];
}

-(void)setRowID: (NSIndexPath*)index{
    [self.singleDeviceViewController setRowID:index];
    self.rowIndex = index;
}

@end
