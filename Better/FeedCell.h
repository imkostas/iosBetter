//
//  FeedCell.h
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//
//  Controls the UI elements that are common to all three types of cells (e.g. the header area)

#import <UIKit/UIKit.h>
#import "Definitions.h"
//#import "FeedCellHeader.h"
#import "BEHotspotView.h"
#import "BELabelFast.h"

@interface FeedCell : UITableViewCell

// The shadow/wrapper view which draws a shadow around itself
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *headerView; // View which contains all header UI elements
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView; // The profile picture
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel; // The tags UILabel
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel; // The username
@property (weak, nonatomic) IBOutlet UILabel	*numberOfVotesLabel; // The number of votes label
//@property (weak, nonatomic) IBOutlet UIImageView *threeDotMenuButton; // The 3-dot menu button

// The 2px divider line between image and header
@property (weak, nonatomic) IBOutlet UIView *dividerView;

// The hotspots
@property (strong, nonatomic) BEHotspotView *hotspotA;
@property (strong, nonatomic) BEHotspotView *hotspotB;

@end
