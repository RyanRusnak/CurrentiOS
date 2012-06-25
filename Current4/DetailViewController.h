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

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
    UIView *view;
    CGRect labelFrame;
    UILabel *nameLabel;
    NSMutableArray *edgesArray;
    int deviceIndex;
    
    UIPopoverController *mainPopoverController;
    UIPopoverController *detailViewPopover;
	UIPopoverController *pinButtonItemPopover;
    UIPopoverController *infoButtonItemPopover;
}

@property (strong, nonatomic) IBOutlet Canvas *canv;
@property (strong, nonatomic) Device *detailItem;
@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) Device *selectedDevice;

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray;
-(void) updateLabels:(NSMutableArray *) inDeviceArray;
-(void) autoRotationUpdate;

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