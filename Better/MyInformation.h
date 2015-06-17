//
//  MyInformation.h
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Definitions.h"
#import "UserInfo.h"
#import "MyInfoTableViewCell.h"

@interface MyInformation : UIViewController <UITableViewDataSource, UITableViewDelegate>

// Profile image and panel
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profilePanel;
@property (weak, nonatomic) IBOutlet UIView *profilePanelOverlay;

// Rank and user information
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageAndGenderLabel;

// Table view for user's My Posts, My Favorites, etc...
@property (weak, nonatomic) IBOutlet UITableView *countsTableView;

// Pressing on bar button items
- (IBAction)backArrowPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

// Refreshing the user's counts
- (void)getCounts;

- (IBAction)cycleRankIcon:(id)sender;

@end
