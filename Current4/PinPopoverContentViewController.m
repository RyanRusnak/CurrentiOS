

#import "PinPopoverContentViewController.h"

@implementation PinPopoverContentViewController

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	
	// Add a label to the popover's view controller.
//	UILabel *popoverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 320., 320.)];
//	popoverLabel.text = @"PIN!";
//	popoverLabel.font = [UIFont boldSystemFontOfSize:100.];
//	popoverLabel.textAlignment = UITextAlignmentCenter;
//	popoverLabel.textColor = [UIColor redColor];
//	[self.view addSubview:popoverLabel];
//    
//    UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 150)];
//    UIImage *pinImage = [UIImage imageNamed:@"deviceprofile-topblock-bg.png"];
//    pinImageView.image = pinImage;
//    [self.view addSubview:pinImageView];
    
    pinImage = [UIImage imageNamed:@"pinboard-0.png"];
    
    pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pinButton.frame = CGRectMake(-30, -20, 500, 600);
    [pinButton setBackgroundImage:pinImage forState:UIControlStateNormal];
    [pinButton addTarget:self action:@selector(pinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pinButton];
	
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

-(void)pinButtonClicked
{
    if (touched==TRUE)
    {
        pinImage = [UIImage imageNamed:@"pinboard-0.png"];
        [pinButton setBackgroundImage:pinImage forState:UIControlStateNormal];
        touched = FALSE;
    }else {
        pinImage = [UIImage imageNamed:@"pinboard-1.png"];
        [pinButton setBackgroundImage:pinImage forState:UIControlStateNormal];
        touched=TRUE;
    }
}


@end
