//
//  ManualsViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualsViewController : UIViewController

- (IBAction)dismissView:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *manualImageView;
@property (strong, nonatomic) IBOutlet UIWebView *webOutlet;
@end
