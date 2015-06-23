//
//  LeaderboardTableViewCell.h
//  Better
//
//  Created by Peter on 6/23/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "BELabel.h"

@interface LeaderboardTableViewCell : UITableViewCell

// UI elements for a leaderboard row
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet BELabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@end
