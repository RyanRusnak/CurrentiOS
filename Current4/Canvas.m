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
    return self;
}

-(void) fillDrawDeviceArray:(NSMutableArray *) inDrawDeviceArray
{
    self.deviceDrawArray = inDrawDeviceArray;
    [self setNeedsDisplay];
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
            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
            
        }
        else if (device.selected == YES)
        {
            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blueColor].CGColor);
            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
        }
    }
[self updateLabels];
}

-(void) drawlabels
{
    nameLabelArray = [[NSMutableArray alloc] init];
    statusLabelArray = [[NSMutableArray alloc] init];
        for(Device *device in _deviceDrawArray)
        {
            labelFrame = CGRectMake(device.vertex.x+1,device.vertex.y+1,78,20);
            nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
            nameLabel.backgroundColor =[UIColor blueColor];
            nameLabel.textColor =[UIColor whiteColor];
            [self addSubview:nameLabel];
            nameLabel.text = device.name;
            [nameLabelArray addObject:nameLabel];
            
            CGRect statusFrame = CGRectMake(device.vertex.x+1,device.vertex.y+80,78,20);
            UILabel *statusLabel = [[UILabel alloc] initWithFrame:statusFrame];
            [self addSubview:statusLabel];
            statusLabel.backgroundColor =[UIColor redColor];
            statusLabel.textColor =[UIColor whiteColor];
            statusLabel.text = device.status;
            [statusLabelArray addObject:statusLabel];
            
        }
}
-(void) updateLabels
{
    int i;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    for (i=0; i< _deviceDrawArray.count; i=i+1)
    {
        label = [nameLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+1, 78,20 );
        label = [statusLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+80, 78,20 );
        
    }
}


@end
