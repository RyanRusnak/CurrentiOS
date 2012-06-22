
#import "InfoPopoverContentViewController.h"

@implementation InfoPopoverContentViewController

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Add a label to the popover's view controller.
	UILabel *popoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 320., 320.)];
	popoverLabel.text = @"INFO!";
	popoverLabel.font = [UIFont boldSystemFontOfSize:100.];
	popoverLabel.textAlignment = UITextAlignmentCenter;
	popoverLabel.textColor = [UIColor redColor];
	
	[self.view addSubview:popoverLabel];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
