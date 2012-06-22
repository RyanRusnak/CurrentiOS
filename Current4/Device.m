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
@synthesize label;
@synthesize frame;
NSRMap(name, incomAddress, createdAt)


- (Device*)initWithIdent:(int)ident andVertex:(CGPoint)vertex andSelected:(BOOL)selected
{
self = [super init];
if(self){
    _ident = ident;
    _vertex = vertex;
    _selected = selected;
    frame = CGRectMake(self.vertex.x, self.vertex.y, 78, 20);
    label = [[UILabel alloc] initWithFrame:frame];
}
return self;
}

@end
