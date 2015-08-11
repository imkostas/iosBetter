//
//  FeedTableViewController.h
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
//#import <SDWebImage/UIImageView+WebCache.h>

#import "Definitions.h"
#import "FeedCellSingleImage.h"
#import "FeedCellLeftRight.h"
#import "FeedCellTopBottom.h"
#import "FeedDataController.h"
#import "ThreeDotViewController.h"

@interface FeedTableViewController : UITableViewController <FeedDataControllerDelegate, FeedCellDelegate, UIViewControllerTransitioningDelegate>

// The source of post data for this class
@property (strong, nonatomic) FeedDataController *dataController;

@end
