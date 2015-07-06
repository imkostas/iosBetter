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
#import "FeedCellHeader.h"
#import "BEHotspotView.h"

@interface FeedCell : UITableViewCell

// The shadow/wrapper view which draws a shadow around itself
@property (weak, nonatomic) IBOutlet UIView *shadowView;

// The view which contains the profile picture, UILabel for tags, the username, etc.
@property (strong, nonatomic) FeedCellHeader *headerView;

// The 2px divider line between image and header
@property (weak, nonatomic) IBOutlet UIView *dividerView;

// The hotspots
@property (strong, nonatomic) BEHotspotView *hotspot1;
@property (strong, nonatomic) BEHotspotView *hotspot2;

@end
