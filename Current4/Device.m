//
//  Post.m
//  Current3
//
//  Created by Ryan Rusnak on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize name, incomAddress, createdAt, status;
@synthesize ident =_ident;
@synthesize vertex = _vertex;
@synthesize selected = _selected;
NSRMap(name, incomAddress, createdAt)


- (Device*)initWithIdent:(int)ident andVertex:(CGPoint)vertex andSelected:(BOOL)selected
{
self = [super init];
if(self){
    _ident = ident;
    _vertex = vertex;
    _selected = selected;
}
return self;
}

@end
