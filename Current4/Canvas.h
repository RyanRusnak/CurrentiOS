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
    UIView *labelView;
}


@property (strong, nonatomic) NSMutableArray *deviceDrawArray;

-(void) fillDrawDeviceArray:(NSMutableArray *) inDrawDeviceArray;

@end
