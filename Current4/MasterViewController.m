//
//  MasterViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 6/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize singleDeviceViewController = _singleDeviceViewController;
@synthesize generalSettingsController = _generalSettingsController;
//@synthesize tabBarController = _tabBarController;

#define SELECTEDDEVICEID

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    devices = [[NSMutableArray alloc] init];
    refreshClicked = FALSE;
    
    UIImage *blueBar = [UIImage imageNamed:@"headbar-bg-r.png"];
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:blueBar forBarMetrics:UIBarMetricsDefault];
	
	[self getDevices];
    
    //self.canvas.deviceDrawArray = [[NSMutableArray alloc] init];

	self.title = @"Device List";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
	
	// Add refresh button
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			 target:self 
																			 action:@selector(showDevices)];
	self.navigationItem.rightBarButtonItem = refresh;

    [super viewDidLoad];
    

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:@"refreshData"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateRotation)
                                                 name:@"updateRotation"
                                               object:nil];   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drillInMaster)
                                                 name:@"drillIn"
                                               object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        [self.detailViewController autoRotationUpdate];
        return YES;
    }
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
    Device *newDevice = [[Device alloc] init];
    newDevice.name = @"New name";
    newDevice.incomAddress = @"New address 111.11.11";
    
    [devices insertObject:newDevice atIndex:0];
    [self.tableView reloadData];
    
//    [devices insertObject:newDevice atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Detected";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	
    Device *device = [devices objectAtIndex:indexPath.row];
    
    if ([device.status intValue] == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"list-status-orange.png"];
    } else if ([device.status intValue] == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"list-status-green.png"];
    }else {
        cell.imageView.image = [UIImage imageNamed:@"list-status-gray.png"];
    }
    
    cell.textLabel.text = device.descLocation;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Comp: %@        Type: %@", device.descBucket, device.deviceType];

        
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSDate *object = [_objects objectAtIndex:indexPath.row];
//        self.detailViewController.detailItem = object;
//    }
    
    for (Device *device in devices){
        device.selected = NO;
    }
    
    Device *device = [devices objectAtIndex:indexPath.row];
    device.selected = YES;
    self.detailViewController.detailItem = device;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingleDeviceViewController *singleDeviceViewController = [[SingleDeviceViewController alloc] initWithStyle:UITableViewStylePlain];
    singleDeviceViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    singleDeviceViewController.rowID =indexPath;
    GeneralSettingsViewController *generalSettingsController = [[GeneralSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    generalSettingsController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    generalSettingsController.rowID =indexPath;
    [self performSegueWithIdentifier: @"presentTab" sender: self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Device *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDeviceArray:devices];
    }
    if ([[segue identifier] isEqualToString:@"presentTab"]){
        [[segue destinationViewController] setRowID:[self.tableView indexPathForSelectedRow]];
    }
}

- (void) getDevices
{
        BOOL changes;
        NSError *error;
        
        BOOL success = [devices remoteFetchAll:[Device class] error:&error changes:&changes];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"status" 
                                                  ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [devices sortedArrayUsingDescriptors:sortDescriptors];
    
    for (Device *device in devices)
    {
        NSLog(@"Device status is%@", device.status);
    }
        
        if (!success)
        {
            [AppDelegate alertForError:error];
        }
        else if (changes)
        {
            [self.tableView reloadData];
        }
}

-(void) showDevices
{
    if (refreshClicked == FALSE) {
        refreshClicked = TRUE;

        for (Device *device in devices)
        {
            if ([device.id intValue] == 5){
                device.vertex=CGPointMake(300, 50);
            }else if ([device.id intValue] == 7){
                device.vertex=CGPointMake(200, 200);
            }else if ([device.id intValue] == 8){
                device.vertex=CGPointMake(400, 200);
            }else if ([device.id intValue] == 9){
                device.vertex=CGPointMake(200, 350);
            }
        }
        
        [self.detailViewController fillDeviceArray:devices];
    }
    else {
        [self updateDevices];
    }
}

-(void) updateDevices
{
    NSMutableArray *vertexArray = [[NSMutableArray alloc]init];
    [vertexArray addObjectsFromArray:devices];
    BOOL changes;
    NSError *error;
    [devices remoteFetchAll:[Device class] error:&error changes:&changes];
    int i= 0;
    
    for (Device *device in devices)
    {
        device.vertex = [[vertexArray objectAtIndex:i]vertex];
        i=i+1;
        //device.status = @"Detected";
        if (([device.id intValue] == 8) && (device.vertex.x > 500))
        {
           device.vertex=CGPointMake(400, 200);
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Device Detected"
                                                              message:@"The system has detected a new device"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Update One Line"
                                                    otherButtonTitles:nil];
            
            [message show];
        }
    }
    [self.tableView reloadData];
    [self.detailViewController updateLabels:devices];
}

- (void) addPost
{
//    [self performSegueWithIdentifier: @"AddPostSeg" sender: self];
    NSLog(@"Attempted to add post");
}

- (void)refreshData:(NSNotification *)notification {
    [self showDevices];
}
-(void)callUpdateRotation
{
    [self.detailViewController autoRotationUpdate];
}
- (void)callDrillInMaster:(NSNotification *)notification {
    [self drillInMaster];
}

-(void)drillInMaster{

    SingleDeviceViewController *singleDeviceViewController = [[SingleDeviceViewController alloc] initWithStyle:UITableViewStylePlain];
    GeneralSettingsViewController *generalSettingsController = [[GeneralSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    for (Device *device in devices)
    {
        if (device.selected == TRUE)
        {
            //NSIndexPath *deviceIndex = [[NSIndexPath alloc] initWithIndex:[devices indexOfObject:device]];
            NSIndexPath *deviceIndex = [NSIndexPath indexPathForRow:[devices indexOfObject:device] inSection:0];
            singleDeviceViewController.rowID = deviceIndex;
            generalSettingsController.rowID =deviceIndex;
        }
    }
    
    [self performSegueWithIdentifier: @"presentTab" sender: self];
}

-(void)copyDevice{
    NSLog(@"Copy clicked");
     [self performSegueWithIdentifier: @"copyList" sender: self];
}

-(int)numberOfNotFoundDevices
{
    devicesNotFound=0;
    for (Device *device in devices)
    {
        if ([device.status intValue] == 0){
            devicesNotFound++;
        }
    }
    return devicesNotFound;
}

@end
