//
//  FeedLeftRightCell.m
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedCellLeftRight.h"

@implementation FeedCellLeftRight

#pragma mark - Initialization
- (void)awakeFromNib
{
	[super awakeFromNib]; // Sets up UI common to all cells
	
	// Initialization code
	
//	CALayer *leftLayer = [[self leftImageView] layer];
//	CALayer *rightLayer = [[self rightImageView] layer];
//	[leftLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[rightLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[leftLayer setShouldRasterize:YES];
//	[rightLayer setShouldRasterize:YES];
    
    // Background color for imageviews
    [[self leftImageView] setBackgroundColor:[UIColor grayColor]];
    [[self rightImageView] setBackgroundColor:[UIColor grayColor]];
    // Masks to bounds
    [[self leftImageView] setClipsToBounds:YES];
    [[self rightImageView] setClipsToBounds:YES];
	
	// Add hotspots as subviews of the left and right ImageViews---
	// hotspot1 --> left image
	// hotspot2 --> right image
	[[self leftImageView] addSubview:[super hotspotA]];
	[[self rightImageView] addSubview:[super hotspotB]];
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
    CGRect leftImageViewFrame = {};
    leftImageViewFrame.size.height = contentViewWidth;
    leftImageViewFrame.size.width = leftImageViewFrame.size.height / 2;
    leftImageViewFrame.origin.x = 0;
    leftImageViewFrame.origin.y = CGRectGetMaxY(dividerViewFrame);
    
    // Set frame for right image view
    CGRect rightImageViewFrame = {};
    rightImageViewFrame.size = leftImageViewFrame.size;
    rightImageViewFrame.origin.x = CGRectGetMaxX(leftImageViewFrame);
    rightImageViewFrame.origin.y = leftImageViewFrame.origin.y;
    
    // Apply the new frames
    [[self leftImageView] setFrame:leftImageViewFrame];
    [[self rightImageView] setFrame:rightImageViewFrame];
    
	// Put the hotspots in the right place
	[[super hotspotA] setFrame:CGRectMake(10, 60, 100, 100)];
	[[super hotspotB] setFrame:CGRectMake(10, 10, 100, 100)];
}

@end
