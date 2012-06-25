//
//  Post.h
//  Current3
//
//  Created by Ryan Rusnak on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSRails.h"

@interface Device : NSRRemoteObject

@property (nonatomic, strong) NSString *name, *incomAddress, *status, *deviceType, *descBucket;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL selected;
@property (assign) CGPoint vertex;
@property (nonatomic, strong) id id;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGRect frame;

- (Device*)initWithIdent:(NSNumber*)ident andVertex:(CGPoint)vertex andSelected:(BOOL)selected;

@end