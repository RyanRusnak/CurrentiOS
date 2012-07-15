
#import "InfoPopoverContentViewController.h"

@implementation infoPopoverContentViewController

@synthesize tableView1;
@synthesize  listofItems;
@synthesize myTextField;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) style:UITableViewStylePlain];
    self.tableView1 = tableView;  
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.tableView1];
    self.view = view;
    
    self.tableView1.dataSource = self;
	
    //Initialize the array.
    listofItems = [[NSMutableArray alloc] init];
    
    NSArray *jobInfo = [NSArray arrayWithObjects:@"Job name", @"Order #", @"Site Address", nil];
    NSDictionary *jobInfoDict = [NSDictionary dictionaryWithObject:jobInfo forKey:@"JobInfo"];
    
    NSArray *customerInfo = [NSArray arrayWithObjects:@"Joe Donetto", @"Vicky Donuts",@"Chris Duncan", nil];
    NSDictionary *customerInfoDict = [NSDictionary dictionaryWithObject:customerInfo forKey:@"JobInfo"];
    
    [listofItems addObject:jobInfoDict];
    [listofItems addObject:customerInfoDict];
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
    
    self.tableView1 = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    
    // Set up the cell...
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,25)];
    myTextField.adjustsFontSizeToFitWidth = YES;
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.textAlignment = UITextAlignmentRight;
    myTextField.delegate = self;
     myTextField.enabled = FALSE;
    cell.accessoryView = myTextField;
    
    if (indexPath.section == 0){
    switch (indexPath.row) {
        case 0:
            myTextField.text = @"Oklahoma Medical";
            break;
            
        case 1:
            myTextField.text = myTextField.text = @"TQA-ISF005297";
            break;
        case 2:
            myTextField.text = myTextField.text = @"567 Penn St Erie, OK";
            myTextField.adjustsFontSizeToFitWidth=YES;
            break;
        default:
            break;
    }
    }
    
    if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                myTextField.text = @"Sales Representitive";
                break;
            case 1:
                myTextField.text = myTextField.text = @"Field Engineer";
                break;
            case 2:
                myTextField.text = myTextField.text = @"General Contractor";
                break;
            default:
                break;
        }
    }
    
    //First get the dictionary object
    NSDictionary *dictionary = [listofItems objectAtIndex:indexPath.section];
    NSArray *jobArray = [dictionary objectForKey:@"JobInfo"];
    NSString *cellValue = [jobArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dictionary = [listofItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"JobInfo"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Job Information";
    else
        return @"Customer Information";
}


@end
