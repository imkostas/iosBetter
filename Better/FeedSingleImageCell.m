//
//  FeedTableViewCell.m
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedSingleImageCell.h"

@implementation FeedSingleImageCell

#pragma mark - Initialization
- (void)awakeFromNib
{
	[super awakeFromNib]; // Sets up UI common to all cells
	
    // Initialization code
	
//	[[[self mainImageView] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[[[self mainImageView] layer] setShouldRasterize:YES];
	
	// Add hotspots as subviews of the ImageView
	[[self mainImageView] addSubview:[super hotspot1]];
	[[self mainImageView] addSubview:[super hotspot2]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - View's ayout
- (void)layoutSubviews
{
	// Set frames of the hotspots
	[[super hotspot1] setFrame:CGRectMake(10, 10, 100, 100)];
	[[super hotspot2] setFrame:CGRectMake(136, 70, 100, 100)];
	
	// Call super
	[super layoutSubviews];
}

@end
