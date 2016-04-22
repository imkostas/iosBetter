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

// Layout definitions
#define FEEDCELL_INSET_TOP 8
#define FEEDCELL_INSET_LEFT 6
#define FEEDCELL_INSET_BOTTOM 8
#define FEEDCELL_INSET_RIGHT 6

#define FEEDCELL_PROFILEIMAGE_WIDTH 56
#define FEEDCELL_PROFILEIMAGE_HEIGHT 56
#define FEEDCELL_PROFILEIMAGE_LEFT 8
#define FEEDCELL_PROFILEIMAGE_RIGHT 16
#define FEEDCELL_PROFILEIMAGE_TOP 22

#define FEEDCELL_THREEDOTIMAGE_WIDTH 6
#define FEEDCELL_THREEDOTIMAGE_HEIGHT 24
#define FEEDCELL_THREEDOTIMAGE_LEFT 16
#define FEEDCELL_THREEDOTIMAGE_RIGHT 8

#define FEEDCELL_VERTSPACE_TAGS_TO_USERNAME 8

#define FEEDCELL_CHECKMARK_WIDTH 20
#define FEEDCELL_CHECKMARK_HEIGHT 20
#define FEEDCELL_CHECKMARK_RIGHT 2

#define FEEDCELL_VOTESLABEL_RIGHT 8

#define FEEDCELL_HEADERVIEW_MIN_HEIGHT 100
#define FEEDCELL_DIVIDERVIEW_HEIGHT 2

// Properties
#define FEEDCELL_TAGSLABEL_MAX_NUM_LINES 3
#define FEEDCELL_TAGSLABEL_FONT_SIZE 15.0f

@interface FeedCell : UITableViewCell

/** Delegate to notify of events */
@property (weak, nonatomic) id<FeedCellDelegate> delegate;

/** Reference to the PostObject that corresponds to this FeedCell.
 Though there are only about 3 or so FeedCell instances created for a feed with many more actual posts,
 every time -tableView:willDisplayCell: is called, this variable will be updated with the PostObject that is
 being displayed at the moment) */
//@property (weak, nonatomic) PostObject *postObject;

// The shadow/wrapper view which draws a shadow around itself
//@property (weak, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *headerView; // View which contains all header UI elements
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView; // The profile picture
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel; // The tags UILabel
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel; // The username
@property (weak, nonatomic) IBOutlet UILabel	*numberOfVotesLabel; // The number of votes label
@property (weak, nonatomic) IBOutlet UIImageView *threeDotImageView; // Image of the 3 dots
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView; // Image of a checkmark
@property (weak, nonatomic) IBOutlet UIButton *threeDotButton; // Button that triggers the 3-dot menu

// The 2px divider line between image and header
@property (weak, nonatomic) IBOutlet UIView *dividerView;

// The hotspots
@property (strong, nonatomic) BEHotspotView *hotspotA;
@property (strong, nonatomic) BEHotspotView *hotspotB;

// Flag to enable and disable the hotspot tap gesture recognizers
@property (nonatomic) BOOL hotspotGesturesEnabled;

@end
