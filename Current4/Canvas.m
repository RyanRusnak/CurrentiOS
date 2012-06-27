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
@synthesize edgeDrawArray = _edgeDrawArray;

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
-(void) fillDrawEdgeArray:(NSMutableArray *) inDrawEdgeArray
{
    self.edgeDrawArray = inDrawEdgeArray;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(_deviceDrawArray==nil){
        _deviceDrawArray = [[NSMutableArray alloc] init];

    }
    if(_edgeDrawArray==nil){
        _edgeDrawArray = [[NSMutableArray alloc] init];
        
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(Edge *edge in _edgeDrawArray){

        [self drawline:[self findDeviceCenterWithIdent:edge.startDeviceId] withPoint:[self findDeviceCenterWithIdent:edge.endDeviceId] inContext:context];        
        //[self drawEdge:edge.startPoint withEndPoint:edge.endPoint inContext:context];
    }
    
    
    CGContextRef deviceBorder = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(deviceBorder, 4.0);
    CGContextSetShadow(deviceBorder, CGSizeMake(10.0f, 10.0f), 10.0f);
    
    for (Device *device in _deviceDrawArray){
        
        if (device.selected == NO)
        {
            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blackColor].CGColor);
            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
            CGContextSetFillColorWithColor(deviceBorder, [UIColor whiteColor].CGColor);
            CGContextFillRect(deviceBorder, rectangle);
        }
        else if (device.selected == YES)
        {
            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blueColor].CGColor);
            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
            CGContextAddRect(deviceBorder, rectangle);
            CGContextStrokePath(deviceBorder);
            CGContextSetFillColorWithColor(deviceBorder, [UIColor whiteColor].CGColor);
            CGContextFillRect(deviceBorder, rectangle);
        }
    }
[self updateLabels];
}

-(void) drawlabels
{
    nameLabelArray = [[NSMutableArray alloc] init];
    statusLabelArray = [[NSMutableArray alloc] init];
    addressLabelArray = [[NSMutableArray alloc] init];
    typeLabelArray = [[NSMutableArray alloc] init];
    bucketLabelArray = [[NSMutableArray alloc] init];
        for(Device *device in _deviceDrawArray)
        {
            labelFrame = CGRectMake(device.vertex.x+1,device.vertex.y+1,78,20);
            nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
            
            if (device.selected == YES)
            {
                nameLabel.backgroundColor =[UIColor blueColor];
            }else
            {
                nameLabel.backgroundColor =[UIColor grayColor];
            }
            
            
            nameLabel.textColor =[UIColor whiteColor];
            [self addSubview:nameLabel];
            nameLabel.text = device.name;
            [nameLabelArray addObject:nameLabel];
            
            typeFrame = CGRectMake(device.vertex.x+1,device.vertex.y+20,78,20);
            typeLabel = [[UILabel alloc] initWithFrame:typeFrame];
            [self addSubview:typeLabel];
            typeLabel.textColor =[UIColor blackColor];
            typeLabel.text = device.deviceType;
            [typeLabelArray addObject:typeLabel];
            
            bucketFrame = CGRectMake(device.vertex.x+1,device.vertex.y+40,78,20);
            bucketLabel = [[UILabel alloc] initWithFrame:bucketFrame];
            [self addSubview:bucketLabel];
            bucketLabel.textColor =[UIColor blackColor];
            bucketLabel.text = device.descBucket;
            [bucketLabelArray addObject:bucketLabel];
            
            addressFrame = CGRectMake(device.vertex.x+1,device.vertex.y+60,78,20);
            addressLabel = [[UILabel alloc] initWithFrame:addressFrame];
            [self addSubview:addressLabel];
            addressLabel.textColor =[UIColor blackColor];
            addressLabel.text = device.incomAddress;
            [addressLabelArray addObject:addressLabel];
            
            statusFrame = CGRectMake(device.vertex.x+1,device.vertex.y+80,78,20);
            statusLabel = [[UILabel alloc] initWithFrame:statusFrame];
            [self addSubview:statusLabel];
            statusLabel.backgroundColor =[UIColor orangeColor];
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
        label.text = [[_deviceDrawArray objectAtIndex:i] name];
        if ([[_deviceDrawArray objectAtIndex:i] selected] == YES)
        {
            label.backgroundColor =[UIColor blueColor];
        }else
        {
            label.backgroundColor =[UIColor grayColor];
        }
        
        label = [statusLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+80, 78,20 );
        label.text = [[_deviceDrawArray objectAtIndex:i] status];
        
        label = [addressLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+60, 78,20 );
        label.text = [NSString stringWithFormat:@"Mod: %@",[[_deviceDrawArray objectAtIndex:i] incomAddress]];
        
        label = [typeLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+20, 78,20 );
        label.text = [[_deviceDrawArray objectAtIndex:i] deviceType];
        
        label = [bucketLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+40, 78,20 );
        label.text = [NSString stringWithFormat:@"Comp: %@",[[_deviceDrawArray objectAtIndex:i] descBucket]];
        
    }
}

- (CGPoint) findDeviceCenterWithIdent:(int)ident{
    CGPoint center;
    for (Device *device in _deviceDrawArray){
        if ((int)device.id == ident)
        {
            return device.vertex; 
        }
    }
    return center;
}

- (CGPoint) createMidPointWithPoint:(int)ident1 andPoint:(int)ident2{
    CGPoint midPoint;
    Device *firstDevice;
    Device *secondDevice;
    for (Device *device in _deviceDrawArray){
        if ((int)device.id == ident1){
            firstDevice = device; 
        }
        if ((int)device.id == ident2){
            secondDevice = device; 
        }
        
        if (firstDevice.vertex.y > secondDevice.vertex.y)
        {
            midPoint = CGPointMake(firstDevice.vertex.x, (((firstDevice.vertex.y - secondDevice.vertex.y)/2)+secondDevice.vertex.y));
        }
        else {
            midPoint = CGPointMake(secondDevice.vertex.x, (((secondDevice.vertex.y - firstDevice.vertex.y)/2)+firstDevice.vertex.y));
        }
    }
    return midPoint;
}

- (int) findMidPointWithPoint:(CGPoint)firstDevice andPoint:(CGPoint)secondDevice{
    CGPoint midPoint;
    
    if (firstDevice.y > secondDevice.y)
    {
        midPoint = CGPointMake(firstDevice.x, (((firstDevice.y - secondDevice.y)/2)+secondDevice.y));
    }
    else {
        midPoint = CGPointMake(secondDevice.x, (((secondDevice.y - firstDevice.y)/2)+firstDevice.y));
    }
    int midY = midPoint.y;
    return midY;
}

- (void)drawEdge:(CGPoint)firstPoint withEndPoint:(CGPoint)secondPoint inContext:(CGContextRef)context
{
	// get the current context
    CGContextRef contextLine = UIGraphicsGetCurrentContext();
    
    // set the stroke color and width
    CGContextSetRGBStrokeColor(contextLine, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(contextLine, 2.0);
    
    // move to your first point
    CGContextMoveToPoint(contextLine, firstPoint.x+40, firstPoint.y+50);
    
    // add a line to your second point
    CGContextAddLineToPoint(contextLine, secondPoint.x+40, secondPoint.y+50);
    
    // tell the context to draw the stroked line
    CGContextStrokePath(contextLine);
}

- (void)drawline:(CGPoint)firstPoint withPoint:(CGPoint)secondPoint inContext:(CGContextRef)context
{
    //Adjust for center
    firstPoint.x = firstPoint.x+40;
    firstPoint.y = firstPoint.y+50;
    secondPoint.x = secondPoint.x+40;
    secondPoint.y = secondPoint.y+50;
    
	// get the current context
    CGContextRef contextLine = UIGraphicsGetCurrentContext();
    
    // set the stroke color and width
    CGContextSetRGBStrokeColor(contextLine, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(contextLine, 2.0);
    
    // move to your first point
    CGContextMoveToPoint(contextLine, firstPoint.x, firstPoint.y);
    CGContextAddLineToPoint(contextLine, firstPoint.x, [self findMidPointWithPoint:firstPoint andPoint:secondPoint]);
    CGContextAddLineToPoint(contextLine, secondPoint.x, [self findMidPointWithPoint:firstPoint andPoint:secondPoint]);
    CGContextAddLineToPoint(contextLine, secondPoint.x, secondPoint.y);
    // tell the context to draw the stroked line
    CGContextStrokePath(contextLine);
}


@end
