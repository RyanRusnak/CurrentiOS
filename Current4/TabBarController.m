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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if(presentedLogin != YES){
    [self performSegueWithIdentifier: @"presentSplash" sender: self];
        presentedLogin = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Add refresh button
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			 target:self 
																			 action:@selector(notifyMaster)];
    self.navigationItem.leftBarButtonItem = refresh;
    
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

@end
