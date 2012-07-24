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



- (Edge*)initWithStartDeviceId:(id)startDeviceId andEndDevice:(id)endDeviceId
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

- (id) getStart_DeviceId
{
    return self.startDeviceId;
}

- (id) getEnd_DeviceId
{
    return self.endDeviceId;
}


@end
