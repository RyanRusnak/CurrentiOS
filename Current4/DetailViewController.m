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
@synthesize twoTouches;
@synthesize pinButtonItemPopover;
@synthesize infoButtonItemPopover;
@synthesize drag = _drag;
@synthesize deviceArray;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize detailLabel = _detailLabel;
@synthesize singleTap = _singleTap;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize canv = _canv;
@synthesize selectedDevice;

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
    [self.canv setNeedsDisplay];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.title = @"One Line";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIImage *blueBar = [UIImage imageNamed:@"headbar-bg-r.png"];
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:blueBar forBarMetrics:UIBarMetricsDefault];
    
#pragma mark bar buttons
    //=============================================SETUP BAR BUTTON ITEMS=================================
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(alterMode) ];
    
    DetailViewController *myDetailView = [[DetailViewController alloc]init];
    myDetailView = self;
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44.01)];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];

//    UIImage *pinImage = [UIImage imageNamed:@"header-btn-pin.png"];
//    UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    pinButton.bounds = CGRectMake( 0, 0, pinImage.size.width, pinImage.size.height );    
//    [pinButton setImage:pinImage forState:UIControlStateNormal];
//    [pinButton addTarget:self action:@selector(pinBoardTouch:) forControlEvents:UIControlEventTouchUpInside];    
//    UIBarButtonItem *pinBarItem = [[UIBarButtonItem alloc] initWithCustomView:pinButton];
//    [buttons addObject:pinBarItem];
    
    UIBarButtonItem *pinButton = [[UIBarButtonItem alloc] initWithTitle:@"Pin" 
                                                               style: UIBarButtonItemStyleBordered
                                                              target:self 
                                                              action:@selector(pinBoardTouch:)];
    [buttons addObject:pinButton];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
                                                                  style: UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(jobInfoTouch:)];
    [buttons addObject:infoButton];
    
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
                                                               style: UIBarButtonItemStyleBordered
                                                              target:self 
                                                              action:@selector(logOutUser)];
    //logOut.tintColor = [UIColor blackColor];
    [buttons addObject:logOut];
     [tools setItems:buttons animated:NO]; 
     [tools setBackgroundImage:blueBar forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    
#pragma mark popovers
    //=============================================SETUP POP OVERS=================================
    PinPopoverContentViewController *pinContent = [[PinPopoverContentViewController alloc] init];
	pinButtonItemPopover = [[UIPopoverController alloc] initWithContentViewController:pinContent];
	pinButtonItemPopover.popoverContentSize = CGSizeMake(320., 320.);
	pinButtonItemPopover.delegate = self;
    
    infoPopoverContentViewController *infoContent = [[infoPopoverContentViewController alloc] init];
	infoButtonItemPopover = [[UIPopoverController alloc] initWithContentViewController:infoContent];
	infoButtonItemPopover.popoverContentSize = CGSizeMake(320., 320.);
	infoButtonItemPopover.delegate = self;
}

- (void)viewDidUnload
{
    [self setDetailLabel:nil];
    [self setCanv:nil];
    [self setSingleTap:nil];
    [self setDrag:nil];
    [self setTwoTouches:nil];
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
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction) pinBoardTouch:(id)sender
{
    // Set the sender to a UIBarButtonItem.
	UIBarButtonItem *tappedButton = (UIBarButtonItem *)sender;
	
	// If the master list popover is showing, dismiss it before presenting the popover from the bar button item.
	if (mainPopoverController != nil) {
        [mainPopoverController dismissPopoverAnimated:YES];
    } 
	
	// If the popover is already showing from the bar button item, dismiss it. Otherwise, present it.
	if (pinButtonItemPopover.popoverVisible == NO) {
		[pinButtonItemPopover presentPopoverFromBarButtonItem:tappedButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[pinButtonItemPopover dismissPopoverAnimated:YES];
	}
}
                               
- (void) logOutUser
{
    NSLog(@"Log Out touch");
    for (Device *device in deviceArray){
        NSLog(@"Ident: %@", device.id);
    }
}

- (void) jobInfoTouch:(id)sender
{
    // Set the sender to a UIBarButtonItem.
	UIBarButtonItem *tappedButton = (UIBarButtonItem *)sender;
	
	// If the master list popover is showing, dismiss it before presenting the popover from the bar button item.
	if (mainPopoverController != nil) {
        [mainPopoverController dismissPopoverAnimated:YES];
    } 
	
	// If the popover is already showing from the bar button item, dismiss it. Otherwise, present it.
	if (infoButtonItemPopover.popoverVisible == NO) {
		[infoButtonItemPopover presentPopoverFromBarButtonItem:tappedButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];		
	}
	else {
		[infoButtonItemPopover dismissPopoverAnimated:YES];
	}
}

- (IBAction)userSingleTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self.view];
    
    BOOL didFindDevice = NO;
    for (Device *device in deviceArray) {
        CGFloat distance = [self DistanceBetweenTwoPoints:device.vertex andPoint:touchPoint];
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

- (IBAction)userDragged:(UIPanGestureRecognizer *)recognizer  {
    
    CGPoint touchPoint = [recognizer locationInView:self.canv];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if(!selectedDevice) {
            for (Device *device in deviceArray) {
                CGFloat distance = [self DistanceBetweenTwoPoints:device.vertex andPoint:touchPoint];
                if (distance < 40){
                    device.selected = YES;
                    self.selectedDevice = device;
                }
                else
                {
                    device.selected = NO;
                }
            }        
        }
        touchPoint.x = touchPoint.x-40;
        touchPoint.y = touchPoint.y-50;
        selectedDevice.vertex = touchPoint;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        self.selectedDevice = nil;
    }
    else {
        touchPoint.x = touchPoint.x-40;
        touchPoint.y = touchPoint.y-50;
        selectedDevice.vertex = touchPoint;
        [self.canv setNeedsDisplay];
    }
    
    //NSLog(@"No of children: %d",[[[self view] subviews] count]);
}

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray
{
    self.deviceArray = inDeviceArray;
    [self.canv fillDrawDeviceArray:deviceArray];
//    [self.singleDeviceViewController fillSingleDeviceArray:deviceArray];
    [self.canv drawlabels];
}

-(void) updateLabels:(NSMutableArray *) inDeviceArray
{
    self.deviceArray = inDeviceArray;
    [self.canv fillDrawDeviceArray:deviceArray];
    [self.canv updateLabels];
}

-(void) autoRotationUpdate
{
    [self.canv fillDrawDeviceArray:deviceArray];
    [self.canv updateLabels];
}

- (float) DistanceBetweenTwoPoints:(CGPoint) point1 andPoint:(CGPoint) point2
{
    CGFloat dx = point2.x - point1.x-30;
    CGFloat dy = point2.y - point1.y-30;
    return sqrt(dx*dx + dy*dy);
}
                               

- (IBAction)tappedTwoDevices:(UITapGestureRecognizer *)sender {
    
    CGPoint touch1 = [sender locationOfTouch:0 inView:self.canv];
    CGPoint touch2 = [sender locationOfTouch:1 inView:self.canv];
    
    BOOL foundDeviceOne = NO;
    BOOL foundDeviceTwo = NO;
    
    Device *device1, *device2;
    for (Device *device in deviceArray) {
        CGFloat distance = [self DistanceBetweenTwoPoints:device.vertex andPoint:touch1];
        CGFloat distance2 = [self DistanceBetweenTwoPoints:device.vertex andPoint:touch2];
        
        if (!foundDeviceOne && distance < 40)
        {
            foundDeviceOne = YES;
            device1 = device;
        }
        if (!foundDeviceTwo && distance2 < 40)
        {
            foundDeviceTwo = YES;
            device2 = device;
        }
    }
    
    if (foundDeviceOne==YES && foundDeviceTwo==YES)
    {
        Edge *edge = [[Edge alloc] initWithStartDeviceId:(int)device1.id andEndDevice:(int)device2.id];
        
//        if (device1.vertex.y > device2.vertex.y){
//            
//            int verticalMidpoint = ((((device1.vertex.y - device2.vertex.y) /2)+device2.vertex.y));
//            CGPoint startPoint = CGPointMake(device1.vertex.x, device1.vertex.y);
//            CGPoint firstMidLinePoint = CGPointMake(device1.vertex.x, verticalMidpoint);
//            CGPoint secondMidLinePoint = CGPointMake(device2.vertex.x, verticalMidpoint);
//            CGPoint endPoint = CGPointMake(device2.vertex.x, device2.vertex.y);
//            Edge *verticalEdgeOne = [[Edge alloc] initWithStartPoint:startPoint andEndPoint:firstMidLinePoint];
//            Edge *midLine = [[Edge alloc] initWithStartPoint:firstMidLinePoint  andEndPoint:secondMidLinePoint];
//            Edge *verticalEdgeTwo = [[Edge alloc] initWithStartPoint:secondMidLinePoint andEndPoint:endPoint];
//            
//            [edgesArray addObject:verticalEdgeOne];
//            [edgesArray addObject:midLine];
//            [edgesArray addObject:verticalEdgeTwo];
//            //[edgesArray addObject:edge];
//        }
//        else {
//            int verticalMidpoint = ((((device2.vertex.y - device1.vertex.y) /2)+device1.vertex.y));
//            CGPoint startPoint = CGPointMake(device1.vertex.x, device1.vertex.y);
//            CGPoint firstMidLinePoint = CGPointMake(device1.vertex.x, verticalMidpoint);
//            CGPoint secondMidLinePoint = CGPointMake(device2.vertex.x, verticalMidpoint);
//            CGPoint endPoint = CGPointMake(device2.vertex.x, device2.vertex.y);
//            Edge *verticalEdgeOne = [[Edge alloc] initWithStartPoint:startPoint andEndPoint:firstMidLinePoint];
//            Edge *midLine = [[Edge alloc] initWithStartPoint:firstMidLinePoint  andEndPoint:secondMidLinePoint];
//            Edge *verticalEdgeTwo = [[Edge alloc] initWithStartPoint:secondMidLinePoint andEndPoint:endPoint];
//            
//            [edgesArray addObject:verticalEdgeOne];
//            [edgesArray addObject:midLine];
//            [edgesArray addObject:verticalEdgeTwo];
//        }
        if(edgesArray==nil){
            edgesArray = [NSMutableArray array];
        }
        [edgesArray addObject:edge];
    }
    deviceIndex++;
    [self.canv fillDrawEdgeArray:edgesArray];
    [self.canv setNeedsDisplay];
}

@end
