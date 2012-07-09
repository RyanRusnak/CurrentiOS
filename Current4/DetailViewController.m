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
@synthesize segControl;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showManual)
                                                 name:@"showManual"
                                               object:nil];
    

    
#pragma mark bar buttons
    //=============================================SETUP BAR BUTTON ITEMS=================================
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(alterMode) ];
    
    DetailViewController *myDetailView = [[DetailViewController alloc]init];
    myDetailView = self;
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 44.01)];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIImage *pinImage = [UIImage imageNamed:@"header-btn-pin.png"];
    UIBarButtonItem *pinButton = [[UIBarButtonItem alloc] initWithImage:pinImage style:UIBarButtonItemStylePlain target:self action:@selector(pinBoardTouch:)];
    pinButton.tintColor = [UIColor blackColor];

//    UIBarButtonItem *pinButton = [[UIBarButtonItem alloc] initWithTitle:@"Pin" 
//                                                               style: UIBarButtonItemStyleBordered
//                                                              target:self 
//                                                              action:@selector(pinBoardTouch:)];
    [buttons addObject:pinButton];
    
//    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
//                                                                  style: UIBarButtonItemStyleBordered
//                                                                 target:self 
//                                                                 action:@selector(jobInfoTouch:)];
    UIImage *infoImage = [UIImage imageNamed:@"header-btn-info.png"];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:infoImage style:UIBarButtonItemStylePlain target:self action:@selector(jobInfoTouch:)];
    infoButton.tintColor = [UIColor blackColor];
    
    [buttons addObject:infoButton];
    
//    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
//                                                               style: UIBarButtonItemStyleBordered
//                                                              target:self 
//                                                              action:@selector(logOutUser:)];
//    //logOut.tintColor = [UIColor blackColor];
//    [buttons addObject:logOut];
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
    
    /*
    myParent = [[MasterViewController alloc] init];
    NSLog(@"the value of parent is %@",myParent);
     */

    elevationVertexArray = [[NSMutableArray alloc]init];
}

- (void)viewDidUnload
{
    [self setDetailLabel:nil];
    [self setCanv:nil];
    [self setSingleTap:nil];
    [self setDrag:nil];
    [self setTwoTouches:nil];
    [self setSegControl:nil];
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
	 NSLog(@"tappedButton is : %@", tappedButton);
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
                               
- (void) logOutUser:(id)sender
{
    NSLog(@"Log Out touch sender is : %@", sender);

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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"drillIn"
                                                                    object:nil];
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

- (IBAction)segmentedControlTouch:(id)sender {
    switch (self.segControl.selectedSegmentIndex) {
        case 0:
            for (Device *device in deviceArray)
            {
                device.vertex = device.elevationVertex;
            }
            [self.canv fillDrawDeviceArray:deviceArray];
            break;
        case 1:
            for (Device *device in deviceArray)
            {
                device.elevationVertex=device.vertex;
                switch ([device.id intValue]) {
                    case 5:
                        device.vertex=CGPointMake(100, 50);
                        break;
                    case 7:
                        device.vertex=CGPointMake(200, 50);
                        break;
                    case 10:
                        device.vertex=CGPointMake(300, 50);
                        break;
                    case 11:
                        device.vertex=CGPointMake(400, 50);
                        break;
                    case 12:
                        device.vertex=CGPointMake(500, 50);
                        break;
                    case 13:
                        device.vertex=CGPointMake(600, 50);
                        break;
                    case 14:
                        device.vertex=CGPointMake(100, 250);
                        break;
                    case 15:
                        device.vertex=CGPointMake(200, 250);
                        break;
                    case 16:
                        device.vertex=CGPointMake(300, 250);
                        break;
                    case 17:
                        device.vertex=CGPointMake(400, 250);
                        break;
                    case 18:
                        device.vertex=CGPointMake(500, 250);
                        break;
                    case 19:
                        device.vertex=CGPointMake(600, 250);
                        break;
                    case 20:
                        device.vertex=CGPointMake(100, 450);
                        break;
                    case 21:
                        device.vertex=CGPointMake(200, 450);
                        break;
                    case 22:
                        device.vertex=CGPointMake(300, 450);
                        break;
                        
                    default:NSLog(@"Different device ID");
                        break;
                }
//                if ([device.id intValue] == 5){
//                    device.vertex=CGPointMake(100, 50);
//                }else if ([device.id intValue] == 7){
//                    device.vertex=CGPointMake(200, 50);
//                }else if ([device.id intValue] == 8){
//                    device.vertex=CGPointMake(300, 50);
//                }else if ([device.id intValue] == 10){
//                    device.vertex=CGPointMake(400, 50);
//                }
            }
            [self.canv fillDrawDeviceArray:deviceArray];
            break;
        default:
            break;
    }
}

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray
{
    self.deviceArray = inDeviceArray;
    
    id id5 = [NSNumber numberWithInteger: 5];
    id id7 = [NSNumber numberWithInteger: 7];
    id id10 = [NSNumber numberWithInteger: 10];
    Edge *edge = [[Edge alloc] initWithStartDeviceId:(int)id5 andEndDevice:(int)id7];
    //Edge *edge2 = [[Edge alloc] initWithStartDeviceId:(int)id5 andEndDevice:(int)id8];
    Edge *edge3 = [[Edge alloc] initWithStartDeviceId:(int)id7 andEndDevice:(int)id10];
    
    if(edgesArray==nil){
        edgesArray = [NSMutableArray array];
    }
    [edgesArray addObject:edge];
    //[edgesArray addObject:edge2];
    [edgesArray addObject:edge3];
    
    for (Device *device in self.deviceArray)
    {
        if ([device.status intValue] == 0)
            device.vertex = CGPointMake(800, 0);
    }
    
    [self.canv fillDrawEdgeArray:edgesArray];
    [self.canv fillDrawDeviceArray:deviceArray];
    [self.canv drawlabels];
    
    //[self.canv setNeedsDisplay];
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
        foundEdge = FALSE;
        for (Edge *currentEdge in edgesArray) {
            if (((currentEdge.startDeviceId == (int)device1.id) && (currentEdge.endDeviceId == (int)device2.id)) || ((currentEdge.startDeviceId == (int)device2.id) && (currentEdge.endDeviceId == (int)device1.id)))
            {
                currentEdge.startDeviceId = 0;
                currentEdge.endDeviceId = 0;
                foundEdge = TRUE;
            }
        }
        if(foundEdge == FALSE)
        {
            
            Edge *edge = [[Edge alloc] initWithStartDeviceId:(int)device1.id andEndDevice:(int)device2.id];
            
            if(edgesArray==nil)
            {
                edgesArray = [NSMutableArray array];
            }
            [edgesArray addObject:edge];
        }
    }
    deviceIndex++;
    [self.canv fillDrawEdgeArray:edgesArray];
    [self.canv setNeedsDisplay];
}

-(int) findSelectedDevice
{
    int selectedDeviceIndex;
    for (Device *device in deviceArray){
        if (device.selected == YES){
            selectedDeviceIndex = [deviceArray indexOfObject:device];
        }
    }
    return selectedDeviceIndex;
}

-(void)showManual
{
    [self performSegueWithIdentifier: @"showManual" sender: self];
}

@end
