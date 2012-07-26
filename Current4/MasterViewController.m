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
	
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 40,44.01)];
    [tools setBackgroundImage:blueBar forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
    UIImage *refreshImage = [UIImage imageNamed:@"header-btn-refresh.png"];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:refreshImage style:UIBarButtonItemStylePlain target:self action:@selector(showDevices)];
    refreshButton.tintColor = [UIColor blackColor];
    
    [buttons addObject:refreshButton];
    [tools setItems:buttons animated:NO]; 
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:tools];

    [super viewDidLoad];
    

        UIBarButtonItem *gear = [[UIBarButtonItem alloc] initWithTitle:@"Gear #1" 
                                                                   style: UIBarButtonItemStyleDone
                                                                  target:self 
                                                                  action:@selector(showGear)];

    self.navigationItem.leftBarButtonItem = gear;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(discoverDevices)
                                                 name:@"discoverDevices"
                                               object:nil];
    
    if ([self numberOfNotFoundDevices]>0) {

        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 275, 60)];
        headerImage = [UIImage imageNamed:@"list-notfound-alert.png"];
        headerImageView.image = headerImage;
        [headerView addSubview:headerImageView];
    
        self.tableView.tableHeaderView = headerView;
    }
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
//    Device *newDevice = [[Device alloc] init];
//    newDevice.name = @"New name";
//    newDevice.incomAddress = @"New address 111.11.11";
//    
//    [devices insertObject:newDevice atIndex:0];
//    [self.tableView reloadData];
    
//    [devices insertObject:newDevice atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self numberOfNotFoundDevices]>0)
    {
        return 2;
    }else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    if ([self numberOfNotFoundDevices]>0)
    {
        if (section == 0)
        {
            return [NSString stringWithFormat:@"Not Found                       %d Devices", [self numberOfNotFoundDevices]];
        }
        else if (section ==1) {
            return [NSString stringWithFormat:@"Detected                        %d Devices", (devices.count- [self numberOfNotFoundDevices])];
        }
    }
    return [NSString stringWithFormat:@"Detected                         %d Devices", (devices.count- [self numberOfNotFoundDevices])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self numberOfNotFoundDevices]>0)
    {
        if (section == 0)
        {
            return [self numberOfNotFoundDevices];
        }
        else if (section ==1) {
            
            return foundDevices.count;
        }
    }
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	
    if ([self numberOfNotFoundDevices]>0)
    {
        if (indexPath.section == 1) {
            Device *device = [foundDevices objectAtIndex:indexPath.row];
            if([device.status intValue] >0 && [device.status intValue] <3)
            {
                cell.textLabel.text = device.descLocation;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Comp: %@        Type: %@", device.descBucket, device.deviceType];
                
                if ([device.status intValue] == 1)
                {
                    cell.imageView.image = [UIImage imageNamed:@"list-status-orange.png"];
                } else if ([device.status intValue] == 2)
                {
                    cell.imageView.image = [UIImage imageNamed:@"list-status-green.png"];
                }
                return cell;
            }
        }
        else if (indexPath.section == 0){
            
            Device *device2 = [notFoundDevices objectAtIndex:indexPath.row];
            cell.textLabel.text = device2.descLocation;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Comp: %@        Type: %@", device2.descBucket, device2.deviceType];
            cell.imageView.image = [UIImage imageNamed:@"list-status-gray.png"];
            
            return cell;
        }
    }else 
    {
        Device *device = [foundDevices objectAtIndex:indexPath.row];
        if([device.status intValue] >0 && [device.status intValue] <3)
        {
            cell.textLabel.text = device.descLocation;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Comp: %@        Type: %@", device.descBucket, device.deviceType];
            
            if ([device.status intValue] == 1)
            {
                cell.imageView.image = [UIImage imageNamed:@"list-status-orange.png"];
            } else if ([device.status intValue] == 2)
            {
                cell.imageView.image = [UIImage imageNamed:@"list-status-green.png"];
            }
            return cell;
        }
    }
    
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
    //self.detailViewController.detailItem = device;
    
    if ([self numberOfNotFoundDevices]>0)
    {
        if(indexPath.section == 0)
        {
            
            Device *touchedDevice = [notFoundDevices objectAtIndex:indexPath.row];
            
            for (Device *deviceKey in devices)
            {
                if (deviceKey.id == touchedDevice.id)
                {
                    notFoundIndex = [NSIndexPath indexPathForRow:[devices indexOfObject:deviceKey] inSection:0];
                }
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            SingleDeviceViewController *singleDeviceViewController = [[SingleDeviceViewController alloc] initWithStyle:UITableViewStylePlain];
            singleDeviceViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            singleDeviceViewController.rowID = notFoundIndex;
            
            GeneralSettingsViewController *generalSettingsController = [[GeneralSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
            generalSettingsController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            generalSettingsController.rowID =notFoundIndex;
            
            [self performSegueWithIdentifier: @"presentTab" sender: self];
        }
        else {
            
            Device *touchedDevice2 = [foundDevices objectAtIndex:indexPath.row];
            
            for (Device *deviceKey2 in devices)
            {
                if (deviceKey2.id == touchedDevice2.id)
                {
                    foundIndex = [NSIndexPath indexPathForRow:[devices indexOfObject:deviceKey2] inSection:1];
                }
            }

            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            SingleDeviceViewController *singleDeviceViewController = [[SingleDeviceViewController alloc] initWithStyle:UITableViewStylePlain];
            singleDeviceViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            singleDeviceViewController.rowID = foundIndex;
            GeneralSettingsViewController *generalSettingsController = [[GeneralSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
            generalSettingsController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            generalSettingsController.rowID =foundIndex;
            
            Device *device = [devices objectAtIndex:foundIndex.row];
            device.selected = YES;
            
            [self performSegueWithIdentifier: @"presentTab" sender: self];
        }
        
    }else {
        Device *touchedDevice2 = [foundDevices objectAtIndex:indexPath.row];
        
        for (Device *deviceKey2 in devices)
        {
            if (deviceKey2.id == touchedDevice2.id)
            {
                foundIndex = [NSIndexPath indexPathForRow:[devices indexOfObject:deviceKey2] inSection:1];
            }
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SingleDeviceViewController *singleDeviceViewController = [[SingleDeviceViewController alloc] initWithStyle:UITableViewStylePlain];
        singleDeviceViewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        singleDeviceViewController.rowID = foundIndex;
        GeneralSettingsViewController *generalSettingsController = [[GeneralSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
        generalSettingsController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        generalSettingsController.rowID =foundIndex;
        
        Device *device = [devices objectAtIndex:foundIndex.row];
        device.selected = YES;
        
        [self performSegueWithIdentifier: @"presentTab" sender: self];
    }
    publicIndex = indexPath;
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
    
    

    
    foundDevices = [[NSMutableArray alloc]init];
    notFoundDevices = [[NSMutableArray alloc]init];
    
    for (Device *device in devices)
    {
        if ([device.status intValue] >0) {
            [foundDevices addObject:device];
        }
        else {
            [notFoundDevices addObject:device];
        }
    }
    
    NSSortDescriptor * statusSort = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES];
    NSSortDescriptor * idSort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    [foundDevices sortUsingDescriptors:[NSArray arrayWithObjects:statusSort,idSort, nil]];
        
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
            switch ([device.id intValue]) {
                case 5:
                    device.vertex=CGPointMake(150, 200);
                    break;
                case 7:
                    device.vertex=CGPointMake(50, 200);
                    break;
                case 10:
                    device.vertex=CGPointMake(50, 350);
                    break;
                case 11:
                    device.vertex=CGPointMake(250, 50);
                    break;
                case 12:
                    device.vertex=CGPointMake(50, 500);
                    break;
                case 13:
                    device.vertex=CGPointMake(150, 500);
                    break;
                case 14:
                    device.vertex=CGPointMake(250, 500);
                    break;
                case 15:
                    device.vertex=CGPointMake(350, 500);
                    break;
                case 16:
                    device.vertex=CGPointMake(450, 500);
                    break;
                case 17:
                    device.vertex=CGPointMake(250, 200);
                    break;
                case 18:
                    device.vertex=CGPointMake(450, 350);
                    break;
                case 19:
                    device.vertex=CGPointMake(350, 350);
                    break;
                case 20:
                    device.vertex=CGPointMake(250, 350);
                    break;
                case 21:
                    device.vertex=CGPointMake(150, 350);
                    break;
                case 22:
                    device.vertex=CGPointMake(550, 500);
                    break;
                case 25:
                    device.vertex=CGPointMake(300, 25);
                    break;
                    
                default:NSLog(@"Different device ID");
                    break;
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
    NSLog(@"-----> REFRESH PRESSED <---------");
    NSMutableArray *vertexArray = [[NSMutableArray alloc]init];
    [vertexArray addObjectsFromArray:devices];
    BOOL changes;
    NSError *error;
    
    [devices removeAllObjects];
    
    [devices remoteFetchAll:[Device class] error:&error changes:&changes];    
    
    int i= 0;
    
    [foundDevices removeAllObjects];
    [notFoundDevices removeAllObjects];
    
    for (Device *device in devices)
    {
       
        device.vertex = [[vertexArray objectAtIndex:i]vertex];
        
        if ([device.status intValue] >0) {
            [foundDevices addObject:device];
        }
        else {
            [notFoundDevices addObject:device];
        }
        
        i++; 
    }
    NSSortDescriptor * statusSort = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES];
    NSSortDescriptor * idSort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    [foundDevices sortUsingDescriptors:[NSArray arrayWithObjects:statusSort,idSort, nil]];
    
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
            NSIndexPath *deviceIndex = [NSIndexPath indexPathForRow:[devices indexOfObject:device] inSection:publicIndex.section];
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

-(void)showGear
{
    [self performSegueWithIdentifier: @"presentGear" sender: self];
}

-(void) discoverDevices
{
    if (!foundOneDevice){
        foundOneDevice=TRUE;
        Device *device = [devices objectAtIndex:2];
        [foundDevices addObject:device];
        
        device.status = [NSNumber numberWithInt:1];
        device.vertex=CGPointMake(400, 200);
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Device Detected"
                                                          message:@"The system has detected a new device"
                                                         delegate:nil
                                                cancelButtonTitle:@"Update One Line"
                                                otherButtonTitles:nil];
        
        [message show];
        
        [devices replaceObjectAtIndex:2 withObject:device];
        
        NSError *error;
        if (![[devices objectAtIndex:2] remoteUpdate:&error])
        {
            [AppDelegate alertForError:error];
        }
    }else {
        Device *device = [devices objectAtIndex:4];
        [foundDevices addObject:device];
        
        device.status = [NSNumber numberWithInt:1];
        device.vertex=CGPointMake(500, 200);
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Device Detected"
                                                          message:@"The system has detected a new device"
                                                         delegate:nil
                                                cancelButtonTitle:@"Update One Line"
                                                otherButtonTitles:nil];
        
        [message show];
        
        [devices replaceObjectAtIndex:4 withObject:device];
        
        NSError *error;
        if (![[devices objectAtIndex:4] remoteUpdate:&error])
        {
            [AppDelegate alertForError:error];
        }
    }
    
    [notFoundDevices removeObjectAtIndex:0];
    NSSortDescriptor * statusSort = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES];
    //NSSortDescriptor * idSort = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    [foundDevices sortUsingDescriptors:[NSArray arrayWithObjects:statusSort, nil]];
    [self updateDevices];
    [headerView removeFromSuperview];
    self.tableView.tableHeaderView = nil;
    [self.tableView reloadData];
}

-(void) drillBack
{
    UINavigationController *nc = [self navigationController];
    [nc popViewControllerAnimated:NO];
}

@end
