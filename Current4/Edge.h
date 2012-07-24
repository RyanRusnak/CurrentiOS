//
//  Edge.h
//  RusnakHW8
//
//  Created by Ryan Rusnak on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Edge : NSObject

@property (nonatomic,strong) id startDeviceId;
@property (nonatomic,strong) id endDeviceId;

@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;



- (Edge*)initWithStartDeviceId:(id)startDeviceId andEndDevice:(id)endDeviceId;

- (Edge*)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint;

- (id) getStart_DeviceId;
- (id) getEnd_DeviceId;

@end
