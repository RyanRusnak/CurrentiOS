//
//  Canvas.m
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Canvas.h"

@implementation Canvas

@synthesize deviceDrawArray = _deviceDrawArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    NSLog(@"outside if");
    return self;
}

-(void) fillDrawDeviceArray:(NSMutableArray *) inDrawDeviceArray
{
    self.deviceDrawArray = inDrawDeviceArray;
    [self setNeedsDisplay];
    NSLog(@"DeviceArray%@", _deviceDrawArray);
}

- (void)drawRect:(CGRect)rect
{
    if(_deviceDrawArray==nil){
        _deviceDrawArray = [[NSMutableArray alloc] init];

    }
    
    CGContextRef deviceBorder = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(deviceBorder, 2.0);
    
    for (Device *device in _deviceDrawArray){
        
        if (device.selected == NO)
        {
            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blackColor].CGColor);
            CGRect rectangle = CGRectMake(device.vertex.x,170,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
        }
        else if (device.selected == YES)
        {
            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor redColor].CGColor);
            CGRect rectangle = CGRectMake(device.vertex.x,170,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
        }
    }
}

@end
