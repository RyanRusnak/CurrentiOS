//
//  CopyViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyViewController : UITableViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
   // NSMutableArray *copyArray;
    UITableView *tableview;
    BOOL checked;
}
-(void)setCopyArray: (NSMutableArray*)copyArraySent;

@property (strong, nonatomic) UITextField *myTextField;
@property (assign) NSUInteger row;

@end
