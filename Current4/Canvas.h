//
//  Canvas.h
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface Canvas : UIView
{
    CGRect labelFrame;
    UILabel *nameLabel;
    CGRect statusFrame;
    UILabel *statusLabel;
    CGRect addressFrame;
    UILabel *addressLabel;
    CGRect typeFrame;
    UILabel *typeLabel;
    CGRect bucketFrame;
    UILabel *bucketLabel;
    NSMutableArray *nameLabelArray;
    NSMutableArray *statusLabelArray;
    NSMutableArray *addressLabelArray;
    NSMutableArray *typeLabelArray;
    NSMutableArray *bucketLabelArray;
}

@property (strong, nonatomic) NSMutableArray *deviceDrawArray;

-(void) fillDrawDeviceArray:(NSMutableArray *) inDrawDeviceArray;
-(void) drawlabels;
-(void) updateLabels;

@end
