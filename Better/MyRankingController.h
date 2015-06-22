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
#import "ExtendedNavBarView.h"
#import "BEPageViewController.h"

// To generate pages for pageviewcontroller
@class MyRanking, Leaderboard;

@interface MyRankingController : UIViewController <BEPageViewControllerDataSource, BEPageViewControllerDelegate>

// The segmented control for switching pages
@property (weak, nonatomic) IBOutlet UISegmentedControl *pageSegmentedControl;
// The view that the seg. control is embedded inside
@property (weak, nonatomic) IBOutlet ExtendedNavBarView *segControlBackground;

// The BEPageViewController which is embedded within a container
@property (weak, nonatomic) BEPageViewController *pageViewController;

// Called when back arrow is pressed
- (IBAction)backArrowPressed:(id)sender;

// Called when user switches the seg. control
- (IBAction)segControlValueChanged:(UISegmentedControl *)sender;

@end
