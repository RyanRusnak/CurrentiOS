//
//  GeneralDeviceViewCOntroller.m
//  Current4
//
//  Created by Ryan Rusnak on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeneralSettingsViewController.h"
#import "AppDelegate.h"

@interface GeneralSettingsViewController (){
    NSMutableArray *_objects;
}

@end

static NSIndexPath* rowSelected;

@implementation GeneralSettingsViewController

//@synthesize singleDeviceArray;
@synthesize deviceArray;
@synthesize rowID;
@synthesize myTextField;
@synthesize row;
@synthesize rowClicked;
@synthesize tempRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    [headerView setBackgroundColor:[UIColor grayColor]];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 150)];
    UIImage *backgroundHeader = [UIImage imageNamed:@"deviceprofile-topblock-bg.png"];
    backgroundImage.image = backgroundHeader;
    [headerView addSubview:backgroundImage];
    
    UIImageView *backgroundBlock = [[UIImageView alloc] initWithFrame:CGRectMake(110, 10, 200, 80)];
    UIImage *backgroundHeaderImage = [UIImage imageNamed:@"deviceprofile-topblock-info-bg.png"];
    backgroundBlock.image = backgroundHeaderImage;
    [headerView addSubview:backgroundBlock];
    
    deviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    UIImage *meter = [UIImage imageNamed:@"header-btn-pin.png"];
    deviceImageView.image = meter;
    [headerView addSubview:deviceImageView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 250, 20)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [headerView addSubview:nameLabel];
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 250, 20)];
    [typeLabel setBackgroundColor:[UIColor clearColor]];
    [typeLabel setTextColor:[UIColor grayColor]];
    [headerView addSubview:typeLabel];
    
    compLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 65, 250, 20)];
    [compLabel setBackgroundColor:[UIColor clearColor]];
    [compLabel setTextColor:[UIColor grayColor]];
    [headerView addSubview:compLabel];
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(170, 100, 145, 45);
    [copy setTitle:@"Copy" forState:UIControlStateNormal];
    [copy addTarget:self action:@selector(copyDevice) forControlEvents:UIControlEventTouchUpInside];
    [copy setBackgroundImage:[UIImage imageNamed:@"deviceprofile-topblock-btn.png"] forState:UIControlStateNormal];
    [headerView addSubview:copy];
    
    UIButton *markAsComplete = [UIButton buttonWithType:UIButtonTypeCustom];
    markAsComplete.frame = CGRectMake(10, 100, 145, 45);
    [markAsComplete setTitle:@"Mark Complete" forState:UIControlStateNormal];
    [markAsComplete addTarget:self action:@selector(markComplete) forControlEvents:UIControlEventTouchUpInside];
    [markAsComplete setBackgroundImage:[UIImage imageNamed:@"deviceprofile-topblock-btn.png"] forState:UIControlStateNormal];
    [headerView addSubview:markAsComplete];
    
    self.tableView.tableHeaderView = headerView;
    
    
    //UIImageView *tabImage1 =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device-tab-general-1.png"]];
    //UIImage* anImage = [UIImage imageNamed:@"device-tab-general-1.png"];
    //UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:anImage tag:0];
    //[self.tabBarController.tabBarItem insertSubview:tabImage1 atIndex:1];
    //[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    //self.tabBarItem.image = [UIImage imageNamed:@"device-tab-general-1.png"];
    
//    UIImageView *tabImage2 =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device-tab-settings-0.png"]];
//    [self.tabBarController.tabBar insertSubview:tabImage2 atIndex:2];
//    UIImageView *tabImage3 =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device-tab-manuals-0.png"]];
//    [self.tabBarController.tabBar insertSubview:tabImage3 atIndex:3];
    
    [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"device-tab-general-0.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"device-tab-general-0.png"]];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    deviceArray = [[NSMutableArray alloc] init];
    
    
    BOOL changes;
    NSError *error;
    
    [deviceArray remoteFetchAll:[Device class] error:&error changes:&changes];
    
    singleDeviceArray = [[NSMutableArray alloc] init];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]upstreamDevice]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]incomAddress]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]macAddress]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]firmware]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]status]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]voltageClass]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]amps]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]powerFactor]];
    
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]lanType]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]hostName]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]domainName]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]modbusTcpEnabled]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]defaultGateway]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]subnetMask]];
    
    nameLabel.text = [[deviceArray objectAtIndex:rowSelected.row]descLocation];
    typeLabel.text = [[deviceArray objectAtIndex:rowSelected.row]deviceType];
    compLabel.text = [[deviceArray objectAtIndex:rowSelected.row]descBucket];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"the row count is %d",singleDeviceArray.count);
    //return singleDeviceArray.count;
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (singleDeviceArray == NULL)
    {
        //[self.tableView reloadData];
        //NSLog (@"singleDeviceArray is: %@", singleDeviceArray);
    }
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,150,25)];
    myTextField.adjustsFontSizeToFitWidth = YES;
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    myTextField.textAlignment = UITextAlignmentRight;
    myTextField.enabled = FALSE;
    myTextField.delegate = self;
    cell.accessoryView = myTextField;
    
    row = [indexPath row];
    
    switch (indexPath.row) {
        case 0:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:0]];
            cell.textLabel.text = @"Upstream";
            break;
        case 1:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:1]];
            cell.textLabel.text = @"Address";
            break;
        case 2:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:2]];
            cell.textLabel.text = @"MAC";
            break;
        case 3:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:3]];
            cell.textLabel.text = @"Firmware";
            break;
        case 4:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:4]];
            cell.textLabel.text = @"Status";
            break;
        case 5:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:5]];
            cell.textLabel.text = @"Voltage Class";
            break;
        case 6:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:6]];
            cell.textLabel.text = @"Amps";
            break;
        case 7:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:7]];
            cell.textLabel.text = @"Power Factor";
            break;
        default:
            NSLog (@"singleDeviceArray is: %@", singleDeviceArray);
            break;
    }
    
    if (row ==5 &&[[singleDeviceArray objectAtIndex:row] intValue] == 0)
    {
        myTextField.text = @"Not Found";
    }else if (row ==4 && [[singleDeviceArray objectAtIndex:row] intValue] == 1) {
        myTextField.text = @"Detected";
    }else if (row ==4 && [[singleDeviceArray objectAtIndex:row] intValue] == 2){
        myTextField.text = @"Configured";
    }else {
        myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:row]];
    }
    
    return cell;
}

#pragma mark table editing methods
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    rowClicked = indexPath.row;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if(textField == myTextField){
    NSError *error;
    
    [singleDeviceArray replaceObjectAtIndex:rowClicked withObject:textField.text];
    
    Device *tempDevice  = [[Device alloc]init];
    tempDevice = [deviceArray objectAtIndex:rowID.row];
    
    tempDevice.name = [singleDeviceArray objectAtIndex:0];
    tempDevice.incomAddress = [singleDeviceArray objectAtIndex:1];
    tempDevice.deviceType = [singleDeviceArray objectAtIndex:2];
    tempDevice.descBucket = [singleDeviceArray objectAtIndex:3];
    tempDevice.status = [singleDeviceArray objectAtIndex:4];
    
    [deviceArray replaceObjectAtIndex:rowID.row withObject:tempDevice];
    
    if (![[deviceArray objectAtIndex:rowID.row] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];
        
        return NO;
    }
    [self.tableView reloadData];
    
    return YES;    
    //}
}

-(void)setRowID:(NSIndexPath *)passedRow{
    
    rowSelected = passedRow;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"presentCopy"]){
        [[segue destinationViewController] setCopyArray:singleDeviceArray];
    }
}

-(void)markComplete
{
    Device *tempDevice  = [[Device alloc]init];
    tempDevice = [deviceArray objectAtIndex:rowSelected.row];
    tempDevice.upstreamDevice = [singleDeviceArray objectAtIndex:0];
    tempDevice.incomAddress = [singleDeviceArray objectAtIndex:1];
    tempDevice.macAddress = [singleDeviceArray objectAtIndex:2];
    tempDevice.firmware = [singleDeviceArray objectAtIndex:3];
    tempDevice.status = [singleDeviceArray objectAtIndex:4];
    tempDevice.voltageClass = [singleDeviceArray objectAtIndex:5];
    tempDevice.amps = [singleDeviceArray objectAtIndex:6];
    tempDevice.powerFactor = [singleDeviceArray objectAtIndex:7];
    tempDevice.status = [NSNumber numberWithInt:2];
    
    [deviceArray replaceObjectAtIndex:rowSelected.row withObject:tempDevice];
    
    NSError *error;
    if (![[deviceArray objectAtIndex:rowSelected.row] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];
    }
    [self.tableView reloadData];
}

-(void) copyDevice
{
 //   CopyViewController *copyController = [[CopyViewController alloc] initWithStyle:UITableViewStylePlain];
//    copyController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
 //   [self.navigationController pushViewController:copyController animated:YES];
//    [self presentModalViewController:copyController animated:YES];

    [self performSegueWithIdentifier:@"presentCopy" sender:self];
}

@end
