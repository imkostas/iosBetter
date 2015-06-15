//
//  MyRanking.h
//  Better
//
//  Created by Peter on 6/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "UserInfo.h"
#import "RankBarView.h"

@interface MyRanking : UIViewController

// Profile picture and profile panel
@property (weak, nonatomic) IBOutlet UIImageView *profilePanel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

// Rank UI elements
@property (weak, nonatomic) IBOutlet RankBarView *rankBar;
@property (weak, nonatomic) IBOutlet UIImageView *crownedIcon;

// Called when back arrow is pressed
- (IBAction)backArrowPressed:(id)sender;

// Outlet to My Ranking / Leaderboard
@property (weak, nonatomic) IBOutlet UISegmentedControl *rankLeaderSegControl;
// Called when the segmented control changes its value
- (IBAction)rankLeaderSegControlChanged:(id)sender;

@end
