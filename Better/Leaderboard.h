//
//  Leaderboard.h
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Leaderboard : UIViewController

// Daily/Weekly/AllTime segmented control
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

// TableView for showing the scores
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Called when user switches between Daily/Weekly/AllTime
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender;


@end
