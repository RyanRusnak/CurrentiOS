//
//  ManualsViewController.h
//  Current4
//
//  Created by Ryan Rusnak on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinPopoverContentViewController.h"

@interface ManualsViewController : UIViewController <UISearchBarDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *mainPopoverController;
	UIPopoverController *pinButtonItemPopover;
}

- (IBAction)dismissView:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *manualImageView;
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIWebView *webOutlet;

- (IBAction)closeTouched:(id)sender;
- (IBAction)pinTouched:(id)sender;

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;
@end
