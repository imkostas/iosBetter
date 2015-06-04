//
//  Following.h
//  Better
//
//  Created by Kostas on 6/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomAlert.h"
#import "UserInfo.h"

@interface Following : UIViewController <UITableViewDelegate, UITableViewDataSource/*, CustomAlertDelegate*/>

//navigation bar
@property (strong, nonatomic) IBOutlet UIImageView *topBar; //top bar
@property (strong, nonatomic) IBOutlet UILabel *topBarTitle; //topr bar title
@property (strong, nonatomic) IBOutlet UIButton *cancelViewBtn; //dismisses view

//table view for displaying chat rooms
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//view variables
@property (nonatomic) UserInfo *user; //user info
//@property (nonatomic, strong) CustomAlert *customAlert; //custom alert

@end
