//
//  Edge.m
//  RusnakHW8
//
//  Created by Ryan Rusnak on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Edge.h"

@implementation Edge

@synthesize startDeviceId = _startDeviceId;
@synthesize endDeviceId = _endDeviceId;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;



- (Edge*)initWithStartDeviceId:(int)startDeviceId andEndDevice:(int)endDeviceId
{
    self = [super init];
    if(self){
        _startDeviceId = startDeviceId;
        _endDeviceId = endDeviceId;
    }
    return self;
}

- (Edge*)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint
{
    self = [super init];
    if(self){
        _startPoint = startPoint;
        _endPoint = endPoint;
    }
    return self;
}

- (int) getStart_DeviceId
{
    return self.startDeviceId;
}

- (int) getEnd_DeviceId
{
    return self.endDeviceId;
}


@end
