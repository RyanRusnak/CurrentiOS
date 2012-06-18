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
	
	BOOL success = [_deviceDrawArray remoteFetchAll:[Device class] error:&error changes:&changes];

    int xPos = 60;
    for (Device *device in _deviceDrawArray){
    
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGRect rectangle = CGRectMake(xPos,170,200,80);
        CGContextAddEllipseInRect(context, rectangle);
        CGContextStrokePath(context);
        xPos+= 20;
    }
}



@end
