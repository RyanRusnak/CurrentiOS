//
//  Post.m
//  Current3
//
//  Created by Ryan Rusnak on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize name, incomAddress, createdAt, status, deviceType, descBucket, descLocation, upstreamDevice, macAddress, firmware, amps, powerFactor, lanType, hostName, ipAddressSetting, subnetMask, defaultGateway, preferredDnsServer, alternateDnsServer, domainName, modbusTcpEnabled, voltageClass;
@synthesize id = _id;
@synthesize vertex = _vertex;
@synthesize selected = _selected;
@synthesize label;
@synthesize frame;
@synthesize elevationVertex;
NSRMap(id, name, incomAddress,deviceType,descBucket, createdAt, status, descLocation, upstreamDevice, macAddress, firmware, amps, powerFactor, lanType, hostName, ipAddressSetting, subnetMask, defaultGateway, preferredDnsServer, alternateDnsServer, domainName, modbusTcpEnabled, voltageClass)


- (Device*)initWithIdent:(id)id andVertex:(CGPoint)vertex andSelected:(BOOL)selected
{
self = [super init];
if(self){
    _id = id;
    _vertex = vertex;
    _selected = selected;
    frame = CGRectMake(self.vertex.x, self.vertex.y, 78, 20);
    label = [[UILabel alloc] initWithFrame:frame];
}
return self;
}

@end
