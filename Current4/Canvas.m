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
@synthesize deviceImage;
@synthesize deviceBackground;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activateCopy)
                                                 name:@"copyMode"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivateCopy)
                                                 name:@"deactivateCopy"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearAndUpdatelabels)
                                                 name:@"clearCanv"
                                               object:nil];
    
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
    
    for(Edge *edge in _edgeDrawArray){

        [self drawline:[self findDeviceCenterWithIdent:edge.startDeviceId] withPoint:[self findDeviceCenterWithIdent:edge.endDeviceId] inContext:context];        
    }
    
    CGContextRef deviceBorder = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(deviceBorder, 4.0);
    CGContextSetShadow(deviceBorder, CGSizeMake(10.0f, 10.0f), 10.0f);
    
//    for (Device *device in _deviceDrawArray){
//        
//        if (device.selected == NO)
//        {
//            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blackColor].CGColor);
//            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
//            CGContextAddRect(deviceBorder, rectangle);
//            CGContextStrokePath(deviceBorder);
//            CGContextSetFillColorWithColor(deviceBorder, [UIColor whiteColor].CGColor);
//            CGContextFillRect(deviceBorder, rectangle);
//        }
//        else if (device.selected == YES)
//        {
//            CGContextSetStrokeColorWithColor(deviceBorder, [UIColor blueColor].CGColor);
//            CGRect rectangle = CGRectMake(device.vertex.x,device.vertex.y,80,100);
//            CGContextAddRect(deviceBorder, rectangle);
//            CGContextStrokePath(deviceBorder);
//            CGContextSetFillColorWithColor(deviceBorder, [UIColor whiteColor].CGColor);
//            CGContextFillRect(deviceBorder, rectangle);
//        }
//    }
[self updateLabels];
}

-(void) drawlabels
{
    nameLabelArray = [[NSMutableArray alloc] init];
    statusLabelArray = [[NSMutableArray alloc] init];
    addressLabelArray = [[NSMutableArray alloc] init];
    typeLabelArray = [[NSMutableArray alloc] init];
    bucketLabelArray = [[NSMutableArray alloc] init];
    deviceImageArray = [[NSMutableArray alloc] init];
    
        for(Device *device in _deviceDrawArray)
        {
            labelFrame = CGRectMake(device.vertex.x+1,device.vertex.y+1,78,20);
            nameLabel = [[UILabel alloc] initWithFrame:labelFrame];
            nameLabel.backgroundColor = [UIColor clearColor];
            
            if (copyMode != TRUE) 
            {
                
                if([device.status intValue] == 1)
                {
                    if(device.selected == YES)
                    {
                        deviceImage = [UIImage imageNamed:@"device-detected-selected.png"];
                        deviceBackground.image = deviceImage;
                    }else {
                        deviceImage = [UIImage imageNamed:@"device-detected-rest.png"];
                        deviceBackground.image = deviceImage;
                    }
                }else {
                    if(device.selected == YES)
                    {
                        deviceImage = [UIImage imageNamed:@"device-complete-selected.png"];
                        deviceBackground.image = deviceImage;
                    }else {
                        deviceImage = [UIImage imageNamed:@"device-complete-rest.png"];
                        deviceBackground.image = deviceImage;
                    }
                }
            }
            else
            {
                if([device.status intValue] == 1)
                {
                    if(device.selected == YES)
                    {
                        deviceImage = [UIImage imageNamed:@"device-detected-copy-0.png"];
                        deviceBackground.image = deviceImage;
                    }else {
                        deviceImage = [UIImage imageNamed:@"device-detected-copy-1.png"];
                        deviceBackground.image = deviceImage;
                    }
                }else {
                    if(device.selected == YES)
                    {
                        deviceImage = [UIImage imageNamed:@"device-complete-copy-0.png"];
                        deviceBackground.image = deviceImage;
                    }else {
                        deviceImage = [UIImage imageNamed:@"device-complete-copy-1.png"];
                        deviceBackground.image = deviceImage;
                    }
                }
            }
            
//            if ((device.selected == YES))
//            {
//                nameLabel.backgroundColor =[UIColor blueColor];
//            }else
//            {
//                nameLabel.backgroundColor =[UIColor grayColor];
//            }
            
            imageFrame = CGRectMake(device.vertex.x-10,device.vertex.y-20,105,140);
            deviceBackground = [[UIImageView alloc] initWithFrame:imageFrame];
            deviceImage = [UIImage imageNamed:@"device-detected-rest.png"];
            deviceBackground.image = deviceImage;
            [self addSubview:deviceBackground];
            [deviceImageArray addObject:deviceBackground];
            
            nameLabel.textColor =[UIColor whiteColor];
            nameLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:nameLabel];
            nameLabel.text = device.descLocation;
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
            
            statusFrame = CGRectMake(device.vertex.x+1,device.vertex.y+85,78,20);
            statusLabel = [[UILabel alloc] initWithFrame:statusFrame];
            [self addSubview:statusLabel];
            
            statusLabel.textColor =[UIColor whiteColor];
            if ([device.status intValue] == 0){
                statusLabel.text = @"Not Found";
                statusLabel.backgroundColor =[UIColor grayColor];
            }else if ([device.status intValue] == 1) {
                statusLabel.text = @"Detected";
                statusLabel.backgroundColor =[UIColor orangeColor];
            }else if ([device.status intValue] == 2) {
                statusLabel.text = @"Complete";
                statusLabel.backgroundColor =[UIColor greenColor];
            }
            [statusLabelArray addObject:statusLabel];

        }
}
-(void) updateLabels
{
    int i;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    
    
    for (i=0; i< _deviceDrawArray.count; i=i+1)
    {
        
        label = [nameLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y-10, 80,30 );
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 2;
        label.minimumFontSize = 8.;
        label.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = UITextAlignmentCenter;
        
        imageView = [deviceImageArray objectAtIndex:i];
        imageView.frame = CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x-10, [[_deviceDrawArray objectAtIndex:i] vertex].y-20, 105,140 );

        
        
        if (copyMode != TRUE)
        {
            if([[[_deviceDrawArray objectAtIndex:i] status] intValue] == 1)
            {
                if([[_deviceDrawArray objectAtIndex:i] selected] == YES)
                {
                    deviceImage = [UIImage imageNamed:@"device-detected-selected.png"];
                }else {
                    deviceImage = [UIImage imageNamed:@"device-detected-rest.png"];
                }
            }else {
                if([[_deviceDrawArray objectAtIndex:i] selected] == YES)
                {
                    deviceImage = [UIImage imageNamed:@"device-complete-selected.png"];
                }else {
                    deviceImage = [UIImage imageNamed:@"device-complete-rest.png"];
                }
            }
        }else {
            if([[[_deviceDrawArray objectAtIndex:i] status] intValue] == 1)
            {
                if([[_deviceDrawArray objectAtIndex:i] selected] == YES)
                {
                    deviceImage = [UIImage imageNamed:@"device-detected-copy-0.png"];
                }else {
                    deviceImage = [UIImage imageNamed:@"device-detected-copy-1.png"];
                }
            }else {
                if([[_deviceDrawArray objectAtIndex:i] selected] == YES)
                {
                    deviceImage = [UIImage imageNamed:@"device-complete-copy-0.png"];
                }else {
                    deviceImage = [UIImage imageNamed:@"device-complete-copy-1.png"];
                }
            }
        }
        
        imageView.image = deviceImage;
        
//        label.text = [[_deviceDrawArray objectAtIndex:i] name];
//        label.backgroundColor = [UIColor clearColor];
//        if ([[_deviceDrawArray objectAtIndex:i] selected] == YES)
//        {
//            label.backgroundColor =[UIColor blueColor];
//        }else
//        {
//            label.backgroundColor =[UIColor grayColor];
//        }
        
        label = [statusLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+85, 78,20 );
        label.numberOfLines = 1;
        label.minimumFontSize = 8.;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = UITextAlignmentCenter;
        //label.text = [NSString stringWithFormat:@"",[[_deviceDrawArray objectAtIndex:i] status]];
        if ([[[_deviceDrawArray objectAtIndex:i] status] intValue] == 0){
            label.text = @"Not Found";
        }else if ([[[_deviceDrawArray objectAtIndex:i] status] intValue] == 1) {
            label.text = @"Detected";
        }else if ([[[_deviceDrawArray objectAtIndex:i] status] intValue] == 2) {
            label.text = @"Complete";
        }
        label.backgroundColor = [UIColor clearColor];
        
        label = [addressLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+60, 78,20 );
        label.text = [NSString stringWithFormat:@"%@",[[_deviceDrawArray objectAtIndex:i] incomAddress]];
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        
        label = [typeLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+20, 78,20 );
        label.text = [[_deviceDrawArray objectAtIndex:i] deviceType];
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        
        label = [bucketLabelArray objectAtIndex:i];
        label.frame= CGRectMake([[_deviceDrawArray objectAtIndex:i] vertex].x+1, [[_deviceDrawArray objectAtIndex:i] vertex].y+40, 78,20 );
        label.text = [NSString stringWithFormat:@"Comp: %@",[[_deviceDrawArray objectAtIndex:i] descBucket]];
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        
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
    CGContextSetRGBStrokeColor(contextLine, 0.0, 0.0, 200.0, 1.0);
    CGContextSetLineWidth(contextLine, 3.0);
    
    // move to your first point
    CGContextMoveToPoint(contextLine, firstPoint.x, firstPoint.y);
    CGContextAddLineToPoint(contextLine, firstPoint.x, [self findMidPointWithPoint:firstPoint andPoint:secondPoint]);
    CGContextAddLineToPoint(contextLine, secondPoint.x, [self findMidPointWithPoint:firstPoint andPoint:secondPoint]);
    CGContextAddLineToPoint(contextLine, secondPoint.x, secondPoint.y);
    // tell the context to draw the stroked line
    CGContextStrokePath(contextLine);
}

-(void) activateCopy
{
    copyMode = TRUE;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];

    for(int i = 10; i<14; i++)
    {
        imageView = [deviceImageArray objectAtIndex:i];
        deviceImage = [UIImage imageNamed:@"device-detected-copy-1.png"];
        imageView.image = deviceImage;
    }
}

-(void) deactivateCopy
{
    copyMode = FALSE;
    [self setNeedsDisplay];
}

//-(void)clearAndUpdatelabels
//{
// 
//    [_deviceDrawArray removeAllObjects];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData"
//                                                        object:nil];
//}

@end
