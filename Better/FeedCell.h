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
#import "PostObject.h"
//#import "FeedCellHeader.h"
#import "BEHotspotView.h"
//#import "BELabelFast.h"

@class FeedCell;
@protocol FeedCellDelegate <NSObject>

@required
/** Tells the delegate that this FeedCell's 3-dot drawer button was tapped */
- (void)threeDotButtonWasTappedForFeedCell:(FeedCell *)cell;

/** Tells the delegate that one of this FeedCell's hotspots was tapped; which one was tapped is given by
the `choice` parameter */
- (void)hotspotWasTappedForFeedCell:(FeedCell *)cell withVoteChoice:(VoteChoice)choice;

@end

@interface FeedCell : UITableViewCell

/** Delegate to notify of events */
@property (weak, nonatomic) id<FeedCellDelegate> delegate;

/** Reference to the PostObject that corresponds to this FeedCell.
 Though there are only about 3 or so FeedCell instances created for a feed with many more actual posts,
 every time -tableView:willDisplayCell: is called, this variable will be updated with the PostObject that is
 being displayed at the moment) */
@property (weak, nonatomic) PostObject *postObject;

// The shadow/wrapper view which draws a shadow around itself
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *headerView; // View which contains all header UI elements
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView; // The profile picture
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel; // The tags UILabel
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel; // The username
@property (weak, nonatomic) IBOutlet UILabel	*numberOfVotesLabel; // The number of votes label

// The 2px divider line between image and header
@property (weak, nonatomic) IBOutlet UIView *dividerView;

// The hotspots
@property (strong, nonatomic) BEHotspotView *hotspotA;
@property (strong, nonatomic) BEHotspotView *hotspotB;

// Flag to enable and disable the hotspot tap gesture recognizers
@property (nonatomic) BOOL hotspotGesturesEnabled;

@end
