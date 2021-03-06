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
@synthesize gridY;
@synthesize gridX;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activateCopy)
                                                 name:@"copyMode"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivateCopy)
                                                 name:@"deactivateCopy"
                                               object:nil];
    

    segControl.enabled = FALSE;
    
#pragma mark bar buttons
    //=============================================SETUP BAR BUTTON ITEMS=================================
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(alterMode) ];
    
    DetailViewController *myDetailView = [[DetailViewController alloc]init];
    myDetailView = self;
    
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 90, 44.01)];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIImage *pinImage = [UIImage imageNamed:@"header-btn-pin-white.png"];
    UIBarButtonItem *pinButton = [[UIBarButtonItem alloc] initWithImage:pinImage style:UIBarButtonItemStylePlain target:self action:@selector(pinBoardTouch:)];
    pinButton.tintColor = [UIColor blackColor];

    [buttons addObject:pinButton];
    
    UIImage *infoImage = [UIImage imageNamed:@"header-btn-info-white.png"];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:infoImage style:UIBarButtonItemStylePlain target:self action:@selector(jobInfoTouch:)];
    infoButton.tintColor = [UIColor blackColor];
    
    [buttons addObject:infoButton];
    
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
    
    
    edgesArray = [NSMutableArray array];
    id12 = [NSNumber numberWithInteger: 12];
    id8 = [NSNumber numberWithInteger: 8];
    id13 = [NSNumber numberWithInteger: 13];
    id15 = [NSNumber numberWithInteger: 15];
    id17 = [NSNumber numberWithInteger: 17];
    id7 = [NSNumber numberWithInteger: 7];
    id5 = [NSNumber numberWithInteger: 5];
    id16 = [NSNumber numberWithInteger: 16];
    id18 = [NSNumber numberWithInteger: 18];
    id10 = [NSNumber numberWithInteger: 10];
    id14 = [NSNumber numberWithInteger: 14];
    id25 = [NSNumber numberWithInteger: 25];

    
    gridX.hidden=YES;
    gridY.hidden=YES;
}

- (void)viewDidUnload
{
    [self setDetailLabel:nil];
    [self setCanv:nil];
    [self setSingleTap:nil];
    [self setDrag:nil];
    [self setTwoTouches:nil];
    [self setSegControl:nil];
    [self setGridY:nil];
    [self setGridX:nil];
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
        [pinButtonItemPopover setPopoverContentSize:CGSizeMake(450, 550) animated:YES];
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
    
    if (touchPoint.x > 650 && touchPoint.y > 650){
        [self discoverDevices];
    }
    
    BOOL didFindDevice = NO;
    for (Device *device in deviceArray) {
        CGFloat distance = [self DistanceBetweenTwoPoints:device.vertex andPoint:touchPoint];
        if (distance < 50){
            didFindDevice = YES;
            
            if(device.selected == YES){
                device.selected=NO;
            }
            else{
                device.selected = YES;
                
                NSLog(@"Device touched is %@", device.descLocation);
                
                if (copyMode != TRUE && [device.id intValue] != 25)
                {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"drillIn"
                                                                    object:nil];
                }
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
                if (distance < 50){
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
            gridX.hidden=TRUE;
            gridY.hidden=TRUE;
            for (Device *device in deviceArray)
            {
                device.vertex = device.elevationVertex;
            }
            [self.canv fillDrawDeviceArray:deviceArray];
            break;
        case 1:
            gridY.hidden=FALSE;
            gridX.hidden=FALSE;
            for (Device *device in deviceArray)
            {
                device.elevationVertex=device.vertex;
                switch ([device.id intValue]) {
                    case 5:
                        device.vertex=CGPointMake(75, 50);
                        break;
                    case 7:
                        device.vertex=CGPointMake(225, 50);
                        break;
                    case 10:
                        device.vertex=CGPointMake(375, 50);
                        break;
                    case 11:
                        device.vertex=CGPointMake(525, 50);
                        break;
                    case 12:
                        device.vertex=CGPointMake(75, 225);
                        break;
                    case 13:
                        device.vertex=CGPointMake(225, 225);
                        break;
                    case 14:
                        device.vertex=CGPointMake(375, 225);
                        break;
                    case 15:
                        device.vertex=CGPointMake(525, 225);
                        break;
                    case 16:
                        device.vertex=CGPointMake(75, 400);
                        break;
                    case 17:
                        device.vertex=CGPointMake(225, 400);
                        break;
                    case 18:
                        device.vertex=CGPointMake(375, 400);
                        break;
                    case 8:
                        device.vertex=CGPointMake(525, 400);
                        break;
                    case 25:
                        device.vertex=CGPointMake(device.vertex.x, -100);
                        break;
                        
                    default:NSLog(@"Different device ID");
                        break;
                }
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

        
        for (Device *device in self.deviceArray)
        {
            if ([device.status intValue] == 0)
                device.vertex = CGPointMake(800, 0);
        }
        
    [self fillEdgeArray];
    [self.canv fillDrawDeviceArray:deviceArray];
    [self.canv drawlabels];
    
    segControl.enabled = TRUE;
    //[self.canv setNeedsDisplay];
}

-(void) updateLabels:(NSMutableArray *) inDeviceArray
{
    self.deviceArray = inDeviceArray;
    
//    for (Device *device in deviceArray){
//    }
    [self.canv fillDrawDeviceArray:deviceArray];
//    [self.canv fillDrawEdgeArray:edgesArray];
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
        
        if (!foundDeviceOne && distance < 50)
        {
            foundDeviceOne = YES;
            device1 = device;
        }
        if (!foundDeviceTwo && distance2 < 50)
        {
            foundDeviceTwo = YES;
            device2 = device;
        }
    }
    
    if (foundDeviceOne==YES && foundDeviceTwo==YES)
    {
        foundEdge = FALSE;
        for (Edge *currentEdge in edgesArray) {
            
            NSString *startDeviceString= [NSString stringWithFormat:@"%@",currentEdge.startDeviceId];
            NSString *endDeviceString= [NSString stringWithFormat:@"%@",currentEdge.endDeviceId];
            NSString *device1String= [NSString stringWithFormat:@"%@",device1.id];
            NSString *device2String= [NSString stringWithFormat:@"%@",device2.id];
                
            if ((([startDeviceString isEqualToString:device1String]) && ([endDeviceString isEqualToString:device2String])) || (([startDeviceString isEqualToString:device2String]) && ([endDeviceString isEqualToString:device1String])))
            {
                currentEdge.startDeviceId = 0;
                currentEdge.endDeviceId = 0;
                foundEdge = TRUE;
            }
        }
        if(foundEdge == FALSE)
        {
            Edge *edge = [[Edge alloc] initWithStartDeviceId:device1.id andEndDevice:device2.id];
            
            if(edgesArray==nil)
            {
                edgesArray = [NSMutableArray array];
            }
            [edgesArray addObject:edge];
            NSLog(@"\nstart id in detail view is %@ and endid is %@",edge.startDeviceId,edge.endDeviceId);
        }
    }
    //deviceIndex++;
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

-(void)activateCopy
{
    copyMode = TRUE;
}

-(void) deactivateCopy 
{
    copyMode = FALSE;
//    
//    Device *tmp = [[Device alloc]init];
//    tmp = [deviceArray objectAtIndex:10];
//    NSLog(@"Device at 10 is %@",tmp.descLocation );
//    tmp = [deviceArray objectAtIndex:8];
//    NSLog(@"Device at 8 is %@",tmp.descLocation );
    
    Device *tempDevice  = [[Device alloc]init];
    tempDevice = [deviceArray objectAtIndex:8];
    tempDevice.upstreamDevice = [[deviceArray objectAtIndex:8]upstreamDevice];
    tempDevice.incomAddress = [[deviceArray objectAtIndex:8]incomAddress];
    tempDevice.macAddress = [[deviceArray objectAtIndex:8]macAddress];
    tempDevice.firmware = [[deviceArray objectAtIndex:8]firmware];
    tempDevice.voltageClass = [[deviceArray objectAtIndex:8]voltageClass];
    tempDevice.amps = [[deviceArray objectAtIndex:8]amps];
    tempDevice.status = [NSNumber numberWithInt:2];
    
    [deviceArray replaceObjectAtIndex:8 withObject:tempDevice];
    
    NSError *error;
    if (![[deviceArray objectAtIndex:8] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];
    }
    
    tempDevice = [deviceArray objectAtIndex:10];
    tempDevice.upstreamDevice = [[deviceArray objectAtIndex:10]upstreamDevice];
    tempDevice.incomAddress = [[deviceArray objectAtIndex:10]incomAddress];
    tempDevice.macAddress = [[deviceArray objectAtIndex:10]macAddress];
    tempDevice.firmware = [[deviceArray objectAtIndex:10]firmware];
    tempDevice.voltageClass = [[deviceArray objectAtIndex:10]voltageClass];
    tempDevice.amps = [[deviceArray objectAtIndex:10]amps];
    tempDevice.status = [NSNumber numberWithInt:2];
    
    [deviceArray replaceObjectAtIndex:10 withObject:tempDevice];
    
    NSError *error1;
    if (![[deviceArray objectAtIndex:10] remoteUpdate:&error1])
    {
        [AppDelegate alertForError:error1];
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData"
                                                        object:nil];
    
    [self.canv setNeedsDisplay];
}

-(void) discoverDevices
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"discoverDevices"
                                                        object:nil];
    
}

-(void)fillEdgeArray
{
    if (!called) 
    {
        Edge *edge1 = [[Edge alloc] initWithStartDeviceId:id25 andEndDevice:id12];
        Edge *edge2 = [[Edge alloc] initWithStartDeviceId:id12 andEndDevice:id13];
        Edge *edge3 = [[Edge alloc] initWithStartDeviceId:id12 andEndDevice:id15];
        Edge *edge4 = [[Edge alloc] initWithStartDeviceId:id12 andEndDevice:id17];
//        Edge *edge5 = [[Edge alloc] initWithStartDeviceId:id13 andEndDevice:id5];
        Edge *edge6 = [[Edge alloc] initWithStartDeviceId:id15 andEndDevice:id16];
        Edge *edge7 = [[Edge alloc] initWithStartDeviceId:id17 andEndDevice:id18];
        Edge *edge8 = [[Edge alloc] initWithStartDeviceId:id7 andEndDevice:id10];
        Edge *edge9 = [[Edge alloc] initWithStartDeviceId:id7 andEndDevice:id14];
        Edge *edge10 = [[Edge alloc] initWithStartDeviceId:id25 andEndDevice:id8];
        Edge *edge11 = [[Edge alloc] initWithStartDeviceId:id8 andEndDevice:id7];
        
        [edgesArray addObject:edge1];
        [edgesArray addObject:edge2];
        [edgesArray addObject:edge3];
        [edgesArray addObject:edge4];
//        [edgesArray addObject:edge5];
        [edgesArray addObject:edge6];
        [edgesArray addObject:edge7];
        [edgesArray addObject:edge8];
        [edgesArray addObject:edge9];
        [edgesArray addObject:edge10];
        [edgesArray addObject:edge11];

    
    [self.canv fillDrawEdgeArray:edgesArray];
        called=TRUE;
    }
}

@end
