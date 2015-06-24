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
#import "BETappableView.h"
#import "BELabel.h"
#import "ExtendedNavBarView.h"
#import "BEPageViewController.h"

// For the 'switcher' (My Ranking / Leaderboard)

// To generate pages for pageviewcontroller
@class MyRanking, Leaderboard;

@interface MyRankingController : UIViewController <BEPageViewControllerDataSource, BEPageViewControllerDelegate, BETappableViewDelegate>

// Tappable areas to switch between My Rank / Leaderboard
@property (weak, nonatomic) IBOutlet BETappableView *myRankingTappableView;
@property (weak, nonatomic) IBOutlet BETappableView *leaderboardTappableView;
// The labels within the tappable areas
@property (weak, nonatomic) IBOutlet BELabel *myRankingLabel;
@property (weak, nonatomic) IBOutlet BELabel *leaderboardLabel;

// The view that the switcher (My Rank / Leaderboard) is embedded inside
@property (weak, nonatomic) IBOutlet ExtendedNavBarView *segControlBackground;

// The BEPageViewController which is embedded within a container
@property (weak, nonatomic) BEPageViewController *pageViewController;

// Called when back arrow is pressed
- (IBAction)backArrowPressed:(id)sender;

@end
