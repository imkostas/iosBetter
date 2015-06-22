//
//  MyRanking.h
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "Definitions.h"
#import "BELabel.h"
#import "RankBarView.h"
#import "BadgesCollectionViewCell.h"

@interface MyRanking : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// Profile pic UI elements
@property (weak, nonatomic) IBOutlet UIImageView *profilePanel;
@property (weak, nonatomic) IBOutlet UIView *profilePanelOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

// Ranking UI elements
@property (weak, nonatomic) IBOutlet BELabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankIcon;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet RankBarView *rankBar;
@property (weak, nonatomic) IBOutlet UIImageView *crownIcon;

// Badges
@property (weak, nonatomic) IBOutlet UICollectionView *badgesCollectionView;

@end
