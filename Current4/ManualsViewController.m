//
//  ManualsViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManualsViewController.h"

@interface ManualsViewController ()

@end

@implementation ManualsViewController
@synthesize manualImageView;
@synthesize webOutlet;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.frame=CGRectMake(0, 0,200,200);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [webOutlet  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@
    //                                                        "http://www.eaton.com/Electrical/USA/ProductsandServices/Residential/GeneratorsTransferSwitches/ProductLiterature/index.htm"]]];// Load index.html to our webview
//    NSString *urlAddress        = [[NSBundle mainBundle] pathForResource:@"index" 
//                                                                  ofType:@"html"]; //you can also use PDF files
    NSString *urlAddress = @"http://www.eaton.com/Electrical/USA/ProductsandServices/PowerQualityandMonitoring/PowerandEnergyMeters/PowerXpertMeter2000/index.htm";
    NSURL *url                  = [NSURL URLWithString:urlAddress];
    //[NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObj    = [NSURLRequest requestWithURL:url];
    [webOutlet loadRequest:requestObj];
    
    //=============================================SETUP POP OVERS=================================
    PinPopoverContentViewController *pinContent = [[PinPopoverContentViewController alloc] init];
	pinButtonItemPopover = [[UIPopoverController alloc] initWithContentViewController:pinContent];
	pinButtonItemPopover.popoverContentSize = CGSizeMake(320., 320.);
	pinButtonItemPopover.delegate = self;

}

- (void)viewDidUnload
{
    [self setManualImageView:nil];
    [self setWebOutlet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)dismissView:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

/////////////////// JAVACSRIPT /////////////////////////
/*
 Search A string inside UIWebView with the use of the javascript function
 */


- (IBAction)closeTouched:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pinTouched:(id)sender {
    // Set the sender to a UIBarButtonItem.
	UIBarButtonItem *tappedButton = (UIBarButtonItem *)sender;
    NSLog(@"tappedButton is : %@", tappedButton);
	// If the master list popover is showing, dismiss it before presenting the popover from the bar button item.
	if (mainPopoverController != nil) {
        [mainPopoverController dismissPopoverAnimated:YES];
    } 
	
	// If the popover is already showing from the bar button item, dismiss it. Otherwise, present it.
	if (pinButtonItemPopover.popoverVisible == NO) {
		[pinButtonItemPopover presentPopoverFromBarButtonItem:tappedButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [pinButtonItemPopover setPopoverContentSize:CGSizeMake(450, 550) animated:YES];
	}
	else {
		[pinButtonItemPopover dismissPopoverAnimated:YES];
	}
}

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    // The JS File   
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [webOutlet stringByEvaluatingJavaScriptFromString:jsString];

    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",str];
    [webOutlet stringByEvaluatingJavaScriptFromString:startSearch];
    
    // Search Occurence Count
    // uiWebview_SearchResultCount - is a javascript var
    NSString *result        = [webOutlet stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

/*
 Removes all highlighted string searched before
 */
- (void)removeAllHighlights
{
    // calls the javascript function to remove html highlights
    [webOutlet stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

///////////////////////////////////////////////////////

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self removeAllHighlights];
    
    int resultCount = [self highlightAllOccurencesOfString:searchBar.text];
    
    // If no occurences of string, show alert message
    if (resultCount <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey!" 
                                                        message:[NSString stringWithFormat:@"No results found for string: %@", searchBar.text]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    // remove kkeyboard
    [searchBar resignFirstResponder];
}

@end
