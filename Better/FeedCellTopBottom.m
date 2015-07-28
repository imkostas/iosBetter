//
//  FeedTopBottomCell.m
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedCellTopBottom.h"

@implementation FeedCellTopBottom

#pragma mark - Initialization
- (void)awakeFromNib
{
	[super awakeFromNib]; // Sets up UI common to all cells
	
    // Initialization code
//	CALayer *topLayer = [[self topImageView] layer];
//	CALayer *bottomLayer = [[self bottomImageView] layer];
//	[topLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[bottomLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[topLayer setShouldRasterize:YES];
//	[bottomLayer setShouldRasterize:YES];
	
	// Add hotspots as subviews of the top and bottom ImageViews---
	// hotspot1 --> top image
	// hotspot2 --> bottom image
	[[self topImageView] addSubview:[super hotspot1]];
	[[self bottomImageView] addSubview:[super hotspot2]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - View's layout
- (void)layoutSubviews
{
	// Put the hotspots in the right place
	[[super hotspot1] setFrame:CGRectMake(80, 10, 100, 100)];
	[[super hotspot2] setFrame:CGRectMake(140, 10, 100, 100)];
	
	// Call super
	[super layoutSubviews];
}

@end
