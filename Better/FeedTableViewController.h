//
//  FeedTableViewController.h
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "FeedSingleImageCell.h"
#import "FeedLeftRightCell.h"
#import "FeedTopBottomCell.h"

@interface FeedTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// The main tableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
