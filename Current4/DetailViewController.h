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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
    UIView *view;
}

@property (strong, nonatomic) IBOutlet Canvas *canv;
@property (strong, nonatomic) Device *detailItem;
@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTap;
- (IBAction)userSingleTapped:(UITapGestureRecognizer *)sender;

-(void) fillDeviceArray:(NSMutableArray *) inDeviceArray;

@end
