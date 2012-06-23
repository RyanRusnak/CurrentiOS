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
    
	
	[self getDevices];
    
    //self.canvas.deviceDrawArray = [[NSMutableArray alloc] init];

	self.title = @"Devices";
	
	// Add refresh button
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			 target:self 
																			 action:@selector(showDevices)];
	self.navigationItem.leftBarButtonItem = refresh;

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDate *object = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    
    Device *device = [devices objectAtIndex:indexPath.row];
	cell.textLabel.text = device.name;
	cell.detailTextLabel.text = device.incomAddress;
	
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
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Device *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setDeviceArray:devices];
    }
}

- (void) getDevices
{
        BOOL changes;
        NSError *error;
        
        BOOL success = [devices remoteFetchAll:[Device class] error:&error changes:&changes];
        
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
        int xPos = 20;
        int yPos = 170;
        for (Device *device in devices)
        {
            device.vertex = CGPointMake(xPos, yPos);
            device.selected = NO;
            xPos+=100;
            
            device.status = @"Detected";
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
        device.status = @"Detected";
    }
    //[self.detailViewController fillDeviceArray:devices];
    [self.tableView reloadData];
    [self.detailViewController updateLabels:devices];
}

- (void) addPost
{
//    [self performSegueWithIdentifier: @"AddPostSeg" sender: self];
    NSLog(@"Attempted to add post");
}


@end
