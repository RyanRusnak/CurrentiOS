
#import <UIKit/UIKit.h>

@interface infoPopoverContentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
}

@property (nonatomic, retain) UITableView *tableView1;
@property (nonatomic, retain) NSMutableArray *listofItems;
@property (strong, nonatomic) UITextField *myTextField;

@end
