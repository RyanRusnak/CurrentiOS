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

@implementation SingleDeviceViewController

@synthesize singleDeviceArray;
@synthesize deviceArray;
@synthesize rowID;
@synthesize myTextField;
@synthesize row;
@synthesize rowClicked;

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
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    deviceArray = [[NSMutableArray alloc] init];
    singleDeviceArray = [[NSMutableArray alloc] init];
    
    
    BOOL changes;
    NSError *error;
    
    [deviceArray remoteFetchAll:[Device class] error:&error changes:&changes];
    
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowID.row]name]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowID.row]incomAddress]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowID.row]deviceType]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowID.row]descBucket]];
    [singleDeviceArray addObject:[[deviceArray objectAtIndex:rowID.row]status]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
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
    
    return singleDeviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"coming in this function : cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

   // NSLog(@"singe device array object at index %@", [[singleDeviceArray objectAtIndex:row]intValue]);
    if (row ==4 &&[[singleDeviceArray objectAtIndex:row] intValue] == 0)
    {
        myTextField.text = @"Not Found";
    }else if (row ==4 && [[singleDeviceArray objectAtIndex:row] intValue] == 1) {
        myTextField.text = @"Detected";
    }else if (row ==4 && [[singleDeviceArray objectAtIndex:row] intValue] == 2){
        myTextField.text = @"Configured";
    }else {
        myTextField.text = [NSString stringWithFormat:@"%@", [singleDeviceArray objectAtIndex:row]];
    }
    
    cell.textLabel.text = myTextField.text;
    
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
    NSLog(@"the value of row clicked in didSelect is %d", rowClicked);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if(textField == myTextField){
    NSError *error;
    
    [singleDeviceArray replaceObjectAtIndex:rowClicked withObject:textField.text];
    
    NSLog(@"rowid.row = %d", rowID.row);
    NSLog(@"row clicked is:%d", rowClicked);
    
    Device *tempDevice  = [[Device alloc]init];
    tempDevice = [deviceArray objectAtIndex:rowID.row];
    
    tempDevice.name = [singleDeviceArray objectAtIndex:0];
    tempDevice.incomAddress = [singleDeviceArray objectAtIndex:1];
    tempDevice.deviceType = [singleDeviceArray objectAtIndex:2];
    tempDevice.descBucket = [singleDeviceArray objectAtIndex:3];
    tempDevice.status = [singleDeviceArray objectAtIndex:4];
    //NSLog(@"the value of rowid.row is %d",rowID.row);
    [deviceArray replaceObjectAtIndex:rowID.row withObject:tempDevice];
    
    if (![[deviceArray objectAtIndex:rowID.row] remoteUpdate:&error])
    {
        [AppDelegate alertForError:error];
        //don't dismiss the input VC
        return NO;
    }
    [self.tableView reloadData];
    
    return YES;    
    //}
}


@end
