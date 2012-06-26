
#import "InfoPopoverContentViewController.h"

@implementation infoPopoverContentViewController

@synthesize tableView;
@synthesize  listofItems;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) style:UITableViewStylePlain];
    self.tableView = tableView;  
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:self.tableView];
    self.view = view;
    
    self.tableView.dataSource = self;
	
    //Initialize the array.
    listofItems = [[NSMutableArray alloc] init];
    
    NSArray *countriesToLiveInArray = [NSArray arrayWithObjects:@"Job name", @"Order #", @"Site Address", nil];
    NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
    
    NSArray *countriesLivedInArray = [NSArray arrayWithObjects:@"Joe Donetto", @"Vicky Donuts", nil];
    NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
    
    [listofItems addObject:countriesToLiveInDict];
    [listofItems addObject:countriesLivedInDict];
	
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
    
    self.tableView = nil;
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
    
    //First get the dictionary object
    NSDictionary *dictionary = [listofItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dictionary = [listofItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Countries"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Job Information";
    else
        return @"Customer Information";
}


@end
