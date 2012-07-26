//
//  CopyViewController.m
//  Current4
//
//  Created by Ryan Rusnak on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CopyViewController.h"

@interface CopyViewController ()

@end

static NSMutableArray* copyArray;

@implementation CopyViewController

@synthesize myTextField;
@synthesize row;

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

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.title =@"Copy Items";
    UIBarButtonItem *apply = [[UIBarButtonItem alloc] initWithTitle:@"Apply" 
                                                                  style: UIBarButtonItemStyleBordered
                                                                 target:self 
                                                                 action:@selector(applySettings)];
	self.navigationItem.rightBarButtonItem = apply;
    NSLog(@"copy array is : %@", copyArray);
    checked= FALSE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    cell.imageView.image = [UIImage imageNamed:@"copy-check.png"];
    checked = TRUE;
    
    switch (indexPath.row) {
        case 0:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:8]];
            cell.textLabel.text = @"LAN Type";
            break;
        case 1:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:9]];
            cell.textLabel.text = @"Host Name";
            break;
        case 2:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:10]];
            cell.textLabel.text = @"Domain Name";
            break;
        case 3:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:11]];
            cell.textLabel.text = @"Modbus TCP";
            break;
        case 4:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:12]];
            cell.textLabel.text = @"Default Gateway";
            break;
        case 5:
            myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:13]];
            cell.textLabel.text = @"Subnet Mask";
            break;
        default:
            NSLog (@"singleDeviceArray is: %@", copyArray);
            break;
    }
    
    if (row ==5 &&[[copyArray objectAtIndex:row] intValue] == 0)
    {
        myTextField.text = @"Not Found";
    }else if (row ==4 && [[copyArray objectAtIndex:row] intValue] == 1) {
        myTextField.text = @"Detected";
    }else if (row ==4 && [[copyArray objectAtIndex:row] intValue] == 2){
        myTextField.text = @"Configured";
    }else {
        myTextField.text = [NSString stringWithFormat:@"%@", [copyArray objectAtIndex:row]];
    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
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
*/

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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (checked ==TRUE){
        cell.imageView.image = nil;
        checked = FALSE;
    }else {
        cell.imageView.image = [UIImage imageNamed:@"copy-check.png"];
        checked = TRUE;
    }
}

-(void)setCopyArray: (NSMutableArray*)copyArraySent{
    copyArray = [[NSMutableArray alloc]init];
    copyArray = copyArraySent;
}

-(void)dismissCopy{
    
    
}

-(void) applySettings
{

    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Settings Applied"
                                                      message:@"Do you want to mark these devices as complete now?"
                                                     delegate:self
                                            cancelButtonTitle:@"Mark"
                                            otherButtonTitles:@"Not Now",nil];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deactivateCopy"
                                                                object:nil];
            break;
            
        default:
            break;
    }
}

@end
