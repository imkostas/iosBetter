//
//  FeedCellHeader.h
//  CustomTableViews
//
//  Created by Peter on 6/30/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCellHeader : UIView

@property (strong, nonatomic) UIImageView *profileImageView; // The profile picture
@property (strong, nonatomic) UILabel *tagsLabel; // The tags UILabel
@property (strong, nonatomic) UILabel *usernameLabel; // The username
@property (strong, nonatomic) UIImageView *checkmarkImage; // Checkmark next to votes
@property (strong, nonatomic) UILabel	*numberOfVotesLabel; // The number of votes label
@property (strong, nonatomic) UIImageView *threeDotMenuButton; // The 3-dot menu button
//@property (strong, nonatomic) UIButton *threeDotMenuButton; // The 3-dot menu button

@end
