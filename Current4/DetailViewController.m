//
//  DetailViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize deviceArray;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailLabel = _detailLabel;
@synthesize singleTap = _singleTap;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize canv = _canv;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Device Name:  %@", self.detailItem.name];
        self.detailLabel.text = [NSString stringWithFormat:@"Device Address:  %@",self.detailItem.incomAddress];
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.title = @"One Line";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(alterMode) ];
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem *pinBoard = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks 
                                                                              target:self 
                                                                              action:@selector(pinBoardTouch)];
    [buttons addObject:pinBoard];
    
    UIBarButtonItem *jobInfo = [[UIBarButtonItem alloc] initWithTitle:@"Job" 
                                                               style: UIBarButtonItemStyleBordered
                                                              target:self 
                                                              action:@selector(jobInfoTouch)];
    [buttons addObject:jobInfo];
    
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                               style: UIBarButtonItemStyleBordered
                                                              target:self 
                                                              action:@selector(logOutUser)];
    [buttons addObject:logOut];
     [tools setItems:buttons animated:NO]; 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
}

- (void)viewDidUnload
{
    [self setDetailLabel:nil];
    [self setCanv:nil];
    [self setSingleTap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) pinBoardTouch
{
    NSLog(@"Pin board touch");
}
                               
- (void) logOutUser
{
    NSLog(@"Log Out touch");
}

- (void) jobInfoTouch
{
    NSLog(@"Job Info touch");
}

- (IBAction)userSingleTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self.view];
    NSLog(@"touches began function called");
    
    BOOL didFindDevice = NO;
    for (Device *device in deviceArray) {
        CGFloat distance = [self DistanceBetweenTwoPoints:device.vertex andPoint:touchPoint];
        NSLog(@"Distance:%f", distance);
        if (distance < 40){
            didFindDevice = YES;
            if(device.selected == YES){
                device.selected=NO;
            }
            else{
                device.selected = YES;
            }
        }
        else
        {
            device.selected = NO;
            
        }
    }
    [self.canv setNeedsDisplay];
}

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray
{
    self.deviceArray = inDeviceArray;
    [self.canv fillDrawDeviceArray:deviceArray];
}

- (float) DistanceBetweenTwoPoints:(CGPoint) point1 andPoint:(CGPoint) point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    
    return sqrt(dx*dx + dy*dy);
}
                               

@end
