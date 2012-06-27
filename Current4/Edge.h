//
//  Edge.h
//  RusnakHW8
//
//  Created by Ryan Rusnak on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Edge : NSObject

@property (assign) int startDeviceId;
@property (assign) int endDeviceId;

@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;



- (Edge*)initWithStartDeviceId:(int)startDeviceId andEndDevice:(int)endDeviceId;

- (Edge*)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint;

@end
