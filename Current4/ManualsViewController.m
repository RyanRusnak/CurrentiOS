//
//  ManualsViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManualsViewController.h"

@interface ManualsViewController ()

@end

@implementation ManualsViewController
@synthesize manualImageView;
@synthesize webOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.frame=CGRectMake(0, 0,200,200);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [webOutlet  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@
                                                        "http://www.eaton.com/Electrical/USA/ProductsandServices/Residential/GeneratorsTransferSwitches/ProductLiterature/index.htm"]]];
}

- (void)viewDidUnload
{
    [self setManualImageView:nil];
    [self setWebOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)dismissView:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
