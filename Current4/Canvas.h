//
//  Canvas.h
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Edge.h"

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
    CGContextRef context;
    
    CGRect imageFrame;
    NSMutableArray *deviceImageArray;
}

@property (strong, nonatomic) NSMutableArray *deviceDrawArray;
@property (strong, nonatomic) NSMutableArray *edgeDrawArray;

@property (strong, nonatomic) UIImageView *deviceBackground;
@property (strong, nonatomic) UIImage *deviceImage;

-(void) fillDrawDeviceArray:(NSMutableArray *) inDrawDeviceArray;
-(void) fillDrawEdgeArray:(NSMutableArray *) inDrawEdgeArray;
-(void) drawlabels;
-(void) updateLabels;

@end
