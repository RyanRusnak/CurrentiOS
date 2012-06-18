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

- (void)setDeviceDrawArray:(id)newDeviceDrawArray
{
    if (_deviceDrawArray != newDeviceDrawArray) {
        _deviceDrawArray = newDeviceDrawArray;
        
        // Update the view.
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if(_deviceDrawArray==nil){
        _deviceDrawArray = [[NSMutableArray alloc] init];

    }
    BOOL changes;
	NSError *error;
	
	[_deviceDrawArray remoteFetchAll:[Device class] error:&error changes:&changes];
    
    CGContextRef deviceBorder = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(deviceBorder, 2.0);
    CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blackColor].CGColor);
    
    int deviceBorderxPos = 20;
    
    for (Device *device in _deviceDrawArray){
        CGRect rectangle = CGRectMake(deviceBorderxPos,170,80,100);
        CGContextAddRect(deviceBorder, rectangle);
        CGContextStrokePath(deviceBorder);
        deviceBorderxPos+= 100;
    }
}

-(void)createLabel
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIView *polygonView = [[UIView alloc] initWithFrame: CGRectMake ( 300, 100, 200, 150)];
    [window addSubview:polygonView];
    
    UILabel *myLabel = [[UILabel alloc]init];
    myLabel.text = @"Labelllll";
    [polygonView addSubview:myLabel];
}


@end
