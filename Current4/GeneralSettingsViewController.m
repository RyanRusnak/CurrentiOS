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
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    UIImage *meter = [UIImage imageNamed:@"header-btn-pin.png"];
    //imageView.image = [UIImage imageNamed:@"header-btn-pin.png"];
    imageView.image = meter;
    [headerView addSubview:imageView];
    
    UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 150, 50)];
    [labelView setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:backgroundLabel];
    
    labelView = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 250, 20)];
    [labelView setBackgroundColor:[UIColor grayColor]];
    [labelView setTextColor:[UIColor whiteColor]];
    labelView.text = @"Office Wing 1";
    [headerView addSubview:labelView];
    
    UIButton *copy = [[UIButton alloc]initWithFrame:CGRectMake(180, 90, 125, 50)];
    [copy addTarget:self 
             action:@selector(copyDevice) 
   forControlEvents:UIControlEventTouchUpInside];
    [copy setTitle:@"Copy" forState:UIControlStateNormal];
    [self makeButtonShiny:copy withBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:copy];
    
    UIButton *markComplete = [[UIButton alloc]initWithFrame:CGRectMake(10, 90, 150, 50)];
    [markComplete addTarget:self 
             action:@selector(markComplete) 
   forControlEvents:UIControlEventTouchUpInside];
    [markComplete setTitle:@"Mark as Complete" forState:UIControlStateNormal];
    [self makeButtonShiny:markComplete withBackgroundColor:[UIColor grayColor]];
    [headerView addSubview:markComplete];
    
    self.tableView.tableHeaderView = headerView;
    
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

- (void)makeButtonShiny:(UIButton*)button withBackgroundColor:(UIColor*)backgroundColor
{
    // Get the button layer and give it rounded corners with a semi-transparant button
    CALayer *layer = button.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 4.0f;
    layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    // Create a shiny layer that goes on top of the button
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = button.layer.bounds;
    // Set the gradient colors
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    // Set the relative positions of the gradien stops
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    // Add the layer to the button
    [button.layer addSublayer:shineLayer];
    
    [button setBackgroundColor:backgroundColor];
}

-(void)markComplete
{
    
}

@end
