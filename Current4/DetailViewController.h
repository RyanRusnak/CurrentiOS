//
//  DetailViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Canvas.h"
#import "PinPopoverContentViewController.h"
#import "InfoPopoverContentViewController.h"
#import "Edge.h"
#import "ManualsViewController.h"
#import "AppDelegate.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
    UIView *view;
    CGRect labelFrame;
    UILabel *nameLabel;
    NSMutableArray *edgesArray;
    int deviceIndex;
    BOOL foundEdge;
    
    UIPopoverController *mainPopoverController;
    UIPopoverController *detailViewPopover;
	UIPopoverController *pinButtonItemPopover;
    UIPopoverController *infoButtonItemPopover;
    NSMutableArray *elevationVertexArray;
    
    BOOL copyMode;
    
    id id12;
    id id8;
    id id13;
    id id15;
    id id17;
    id id7;
    id id5;
    id id16;
    id id18;
    id id10;
    id id14;
    id id25;
    
    BOOL called;
}

//@property (strong, nonatomic) MasterViewController *myParent;
@property (strong, nonatomic) IBOutlet Canvas *canv;
@property (strong, nonatomic) Device *detailItem;
@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) Device *selectedDevice;
@property (strong, nonatomic) IBOutlet UIImageView *gridY;
@property (strong, nonatomic) IBOutlet UIImageView *gridX;

- (IBAction)segmentedControlTouch:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray;
-(void) updateLabels:(NSMutableArray *) inDeviceArray;
-(void) autoRotationUpdate;
-(int) findSelectedDevice;

//////////////GESTURE RECOGNIZERS/////////////
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTap;
- (IBAction)userSingleTapped:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *drag;
- (IBAction)userDragged:(UIPanGestureRecognizer *)recognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *twoTouches;
- (IBAction)tappedTwoDevices:(UITapGestureRecognizer *)sender;

/////////////POPOVERS/////////////////////////
@property (nonatomic, retain) UIPopoverController *pinButtonItemPopover;
- (IBAction) pinBoardTouch:(id)sender;
@property (nonatomic, retain) UIPopoverController *infoButtonItemPopover;


@end
