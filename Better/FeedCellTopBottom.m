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
    
    // Background color for imageviews
    [[self topImageView] setBackgroundColor:[UIColor grayColor]];
    [[self bottomImageView] setBackgroundColor:[UIColor grayColor]];
    // Clip to bounds
    [[self topImageView] setClipsToBounds:YES];
    [[self bottomImageView] setClipsToBounds:YES];
	
	// Add hotspots as subviews of the top and bottom ImageViews---
	// hotspot1 --> top image
	// hotspot2 --> bottom image
	[[self topImageView] addSubview:[super hotspotA]];
	[[self bottomImageView] addSubview:[super hotspotB]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - View's layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Get some values first
    CGFloat contentViewWidth = CGRectGetWidth([[self contentView] bounds]);
    CGRect dividerViewFrame = [[super dividerView] frame];
    
    // Set frame for left image view
    CGRect topImageViewFrame = {};
    topImageViewFrame.size.width = contentViewWidth;
    topImageViewFrame.size.height = topImageViewFrame.size.width / 2;
    topImageViewFrame.origin.x = 0;
    topImageViewFrame.origin.y = CGRectGetMaxY(dividerViewFrame);
    
    // Set frame for right image view
    CGRect bottomImageViewFrame = {};
    bottomImageViewFrame.size = topImageViewFrame.size;
    bottomImageViewFrame.origin.x = topImageViewFrame.origin.x;
    bottomImageViewFrame.origin.y = CGRectGetMaxY(topImageViewFrame);
    
    // Apply the new frames
    [[self topImageView] setFrame:topImageViewFrame];
    [[self bottomImageView] setFrame:bottomImageViewFrame];
    
	// Put the hotspots in the right place
	[[super hotspotA] setFrame:CGRectMake(80, 10, 100, 100)];
	[[super hotspotB] setFrame:CGRectMake(140, 10, 100, 100)];
}

@end
