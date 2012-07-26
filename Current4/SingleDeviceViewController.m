//
//  SingleDeviceViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleDeviceViewController.h"
#import "AppDelegate.h"

@interface SingleDeviceViewController (){
    NSMutableArray *_objects;
}

@end

static NSIndexPath* rowSelected;

@implementation SingleDeviceViewController

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
    
    deviceArray = [[NSMutableArray alloc] init];
    
    
    BOOL changes;
    NSError *error;
    
    [deviceArray remoteFetchAll:[Device class] error:&error changes:&changes];
    
    singleDeviceArray = [[NSMutableArray alloc] init];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]lanType]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]hostName]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]ipAddressSetting]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]incomAddress]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]subnetMask]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]defaultGateway]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]preferredDnsServer]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]alternateDnsServer]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]domainName]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowSelected.row]modbusTcpEnabled]];
    
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
    
    deviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 97, 96)];
    UIImage *meter1 = [[UIImage alloc] init];
    meter1 = [UIImage imageNamed:@"deviceprofile-topblock-img-relay.png"];
    
    if ([[[deviceArray objectAtIndex:rowSelected.row]deviceType] isEqualToString:@"PXM 2000"] || [[[deviceArray objectAtIndex:rowSelected.row]deviceType] isEqualToString:@"IQ 250"])
    {
        deviceImageView.image = [UIImage imageNamed:@"deviceprofile-topblock-img-meter"];
    }else {
        deviceImageView.image = [UIImage imageNamed:@"deviceprofile-topblock-img-relay"];
    }
    [headerView addSubview:deviceImageView];
    
    if ([[[deviceArray objectAtIndex:rowSelected.row]status]intValue] == 1)
    {
        imageStatusView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 97, 96)];
        imageStatus = [UIImage imageNamed:@"deviceprofile-topblock-status-detected.png"];
        imageStatusView.image = imageStatus;
        [headerView addSubview:imageStatusView];
    }else if ([[[deviceArray objectAtIndex:rowSelected.row]status]intValue] == 2)
    {
        imageStatusView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 97, 96)];
        imageStatus = [UIImage imageNamed:@"deviceprofile-topblock-status-complete.png"];
        imageStatusView.image = imageStatus;
        [headerView addSubview:imageStatusView];
    }else if ([[[deviceArray objectAtIndex:rowSelected.row]status]intValue] == 0)
    {
        imageStatusView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 97, 96)];
        imageStatus = [UIImage imageNamed:@"deviceprofile-topblock-status-notfound.png"];
        imageStatusView.image = imageStatus;
        [headerView addSubview:imageStatusView];
    }
    
    UIImageView *imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 97, 96)];
    UIImage *imageMask = [UIImage imageNamed:@"deviceprofile-topblock-img-frame.png"];
    imageMaskView.image = imageMask;
    [headerView addSubview:imageMaskView];
    
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
    copy.frame = CGRectMake(170, 105, 145, 45);
    [copy setTitle:@"Copy" forState:UIControlStateNormal];
    [copy addTarget:self action:@selector(copyDevice) forControlEvents:UIControlEventTouchUpInside];
    [copy setBackgroundImage:[UIImage imageNamed:@"deviceprofile-topblock-btn.png"] forState:UIControlStateNormal];
    [headerView addSubview:copy];
    
    UIButton *markAsComplete = [UIButton buttonWithType:UIButtonTypeCustom];
    markAsComplete.frame = CGRectMake(10, 105, 145, 45);
    [markAsComplete setTitle:@"Mark Complete" forState:UIControlStateNormal];
    [markAsComplete addTarget:self action:@selector(markComplete) forControlEvents:UIControlEventTouchUpInside];
    [markAsComplete setBackgroundImage:[UIImage imageNamed:@"deviceprofile-topblock-btn.png"] forState:UIControlStateNormal];
    [headerView addSubview:markAsComplete];
    
    nameLabel.text = [[deviceArray objectAtIndex:rowSelected.row]descLocation];
    typeLabel.text = [[deviceArray objectAtIndex:rowSelected.row]deviceType];
    compLabel.text = [[deviceArray objectAtIndex:rowSelected.row]descBucket];
    
    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSLog(@"the row count is %d",singleDeviceArray.count);
    return singleDeviceArray.count;
    //return 5;
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
    
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,125,25)];
    myTextField.adjustsFontSizeToFitWidth = NO;
    myTextField.backgroundColor = [UIColor clearColor];
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    myTextField.textAlignment = UITextAlignmentRight;
    myTextField.keyboardType = UIKeyboardTypeDefault;
    myTextField.returnKeyType = UIReturnKeyDone;
    myTextField.clearButtonMode = UITextFieldViewModeNever;
    myTextField.delegate = self;
    cell.accessoryView = myTextField;
    
    row = [indexPath row];
    
    switch (indexPath.row) {
        case 0:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:0]];
            cell.textLabel.text = @"LAN Type";
            break;
        case 1:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:1]];
            cell.textLabel.text = @"Host Name";
            break;
        case 2:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:2]];
            cell.textLabel.text = @"IP Setting";
            break;
        case 3:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:3]];
            cell.textLabel.text = @"Address";
            break;
        case 4:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:4]];
            cell.textLabel.text = @"Subnet Mask";
            break;
        case 5:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:5]];
            cell.textLabel.text = @"Default Gateway";
            break;
        case 6:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:6]];
            cell.textLabel.text = @"DNS Server";
            break;
        case 7:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:7]];
            cell.textLabel.text = @"Alternate DNS";
            break;
        case 8:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:8]];
            cell.textLabel.text = @"Domain Name";
            break;
        case 9:
            myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:9]];
            cell.textLabel.text = @"Modbus TCP";
            break;
        default:
            NSLog (@"singleDeviceArray is: %@", singleDeviceArray);
            break;
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
    
    if (rowClicked == 9){
        [self enableModbus];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if(textField == myTextField){
    NSError *error;
    
    [singleDeviceArray replaceObjectAtIndex:rowClicked withObject:textField.text];
    
    Device *tempDevice  = [[Device alloc]init];
    tempDevice = [deviceArray objectAtIndex:rowSelected.row];
    
    tempDevice.lanType = [singleDeviceArray objectAtIndex:0];
    tempDevice.hostName = [singleDeviceArray objectAtIndex:1];
    tempDevice.ipAddressSetting = [singleDeviceArray objectAtIndex:2];
    tempDevice.incomAddress = [singleDeviceArray objectAtIndex:3];
    tempDevice.subnetMask = [singleDeviceArray objectAtIndex:4];
    tempDevice.defaultGateway = [singleDeviceArray objectAtIndex:5];
    tempDevice.preferredDnsServer = [singleDeviceArray objectAtIndex:6];
    tempDevice.alternateDnsServer = [singleDeviceArray objectAtIndex:7];
    tempDevice.domainName = [singleDeviceArray objectAtIndex:8];
    tempDevice.modbusTcpEnabled = [singleDeviceArray objectAtIndex:9];
    tempDevice.status = [NSNumber numberWithInt:1];

    [deviceArray replaceObjectAtIndex:rowSelected.row withObject:tempDevice];
    
    if (![[deviceArray objectAtIndex:rowSelected.row] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];

        return NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData"
                                                        object:nil];
    
    imageStatus = [UIImage imageNamed:@"deviceprofile-topblock-status-detected.png"];
    imageStatusView.image = imageStatus;
    
    [self.tableView reloadData];
    
    return YES;    
    //}
}

-(void)setRowID:(NSIndexPath *)passedRow{

    rowSelected = passedRow;
    NSLog(@"Row selected= %d", rowSelected.row);
}

-(void) enableModbus{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Are you sure you want to enable Modbus TCP?"
                                  delegate:self
                                  cancelButtonTitle:@"No"
                                  destructiveButtonTitle:@"Yes"
                                  otherButtonTitles:@"No", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)action didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [singleDeviceArray replaceObjectAtIndex:9 withObject:@"Enabled"];
        
        Device *tempDevice  = [[Device alloc]init];
        tempDevice = [deviceArray objectAtIndex:rowID.row];
        tempDevice.lanType = [singleDeviceArray objectAtIndex:0];
        tempDevice.hostName = [singleDeviceArray objectAtIndex:1];
        tempDevice.ipAddressSetting = [singleDeviceArray objectAtIndex:2];
        tempDevice.incomAddress = [singleDeviceArray objectAtIndex:3];
        tempDevice.subnetMask = [singleDeviceArray objectAtIndex:4];
        tempDevice.defaultGateway = [singleDeviceArray objectAtIndex:5];
        tempDevice.preferredDnsServer = [singleDeviceArray objectAtIndex:6];
        tempDevice.alternateDnsServer = [singleDeviceArray objectAtIndex:7];
        tempDevice.domainName = [singleDeviceArray objectAtIndex:8];
        tempDevice.modbusTcpEnabled = [singleDeviceArray objectAtIndex:9];
 
        [deviceArray replaceObjectAtIndex:rowSelected.row withObject:tempDevice];
        NSLog(@"Row ID.row: %d", rowSelected.row);
        
        NSError *error;
        if (![[deviceArray objectAtIndex:rowSelected.row] remoteUpdate:&error])
        {
            [AppDelegate alertForError:error];
        }
        [self.tableView reloadData];
    }
}

-(void)markComplete
{
    Device *tempDevice  = [[Device alloc]init];
    
    tempDevice = [deviceArray objectAtIndex:rowSelected.row];
    
    tempDevice.lanType = [singleDeviceArray objectAtIndex:0];
    tempDevice.hostName = [singleDeviceArray objectAtIndex:1];
    tempDevice.ipAddressSetting = [singleDeviceArray objectAtIndex:2];
    tempDevice.incomAddress = [singleDeviceArray objectAtIndex:3];
    tempDevice.subnetMask = [singleDeviceArray objectAtIndex:4];
    tempDevice.defaultGateway = [singleDeviceArray objectAtIndex:5];
    tempDevice.preferredDnsServer = [singleDeviceArray objectAtIndex:6];
    tempDevice.alternateDnsServer = [singleDeviceArray objectAtIndex:7];
    tempDevice.domainName = [singleDeviceArray objectAtIndex:8];
    tempDevice.modbusTcpEnabled = [singleDeviceArray objectAtIndex:9];
    tempDevice.status = [NSNumber numberWithInt:2];
    
    [deviceArray replaceObjectAtIndex:rowSelected.row withObject:tempDevice];
    
    NSError *error;
    if (![[deviceArray objectAtIndex:rowSelected.row] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData"
                                                        object:nil];
    
    imageStatus = [UIImage imageNamed:@"deviceprofile-topblock-status-complete.png"];
    imageStatusView.image = imageStatus;
    
    [self.tableView reloadData];
    UINavigationController *nc = [self navigationController];
    [nc popViewControllerAnimated:YES];
}

-(void) copyDevice
{
    [self performSegueWithIdentifier:@"presentCopy" sender:self];
}

@end
