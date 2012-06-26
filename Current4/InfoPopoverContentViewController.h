
#import <UIKit/UIKit.h>

@interface infoPopoverContentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *listofItems;

@end
