//
//  Post.h
//  Current3
//
//  Created by Ryan Rusnak on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSRails.h"

@interface Device : NSRRemoteObject

@property (nonatomic, strong) NSString *name, *incomAddress, *deviceType, *descBucket, *descLocation,*upstreamDevice, *macAddress, *firmware, *amps, *powerFactor, *lanType, *hostName, *ipAddressSetting, *subnetMask, *defaultGateway, *preferredDnsServer, *alternateDnsServer, *domainName, *modbusTcpEnabled, *voltageClass;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL selected;
@property (assign) CGPoint vertex;
@property (assign) CGPoint elevationVertex;
@property (nonatomic, strong) id id;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSNumber *status;

- (Device*)initWithIdent:(NSNumber*)ident andVertex:(CGPoint)vertex andSelected:(BOOL)selected;

@end
