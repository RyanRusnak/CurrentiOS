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

- (Edge*)initWithStartDeviceId:(int)startDeviceId andEndDevice:(int)endDeviceId
{
    self = [super init];
    if(self){
        _startDeviceId = startDeviceId;
        _endDeviceId = endDeviceId;
    }
    return self;
}


@end
