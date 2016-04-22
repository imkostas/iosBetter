//
//  FeedTableViewCell.m
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedCellSingleImage.h"

@implementation FeedCellSingleImage

#pragma mark - Initialization
- (void)awakeFromNib
{
	[super awakeFromNib]; // Sets up UI common to all cells
	
    // Initialization code
	
//	[[[self mainImageView] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
//	[[[self mainImageView] layer] setShouldRasterize:YES];
    
    // Set up ImageView
    [[self mainImageView] setBackgroundColor:[UIColor grayColor]];
    [[self mainImageView] setClipsToBounds:YES];
	
	// Add hotspots as subviews of the ImageView
	[[self mainImageView] addSubview:[super hotspotA]];
	[[self mainImageView] addSubview:[super hotspotB]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - View's ayout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Get some values first
    CGFloat contentViewWidth = CGRectGetWidth([[self contentView] bounds]);
    CGRect dividerViewFrame = [[super dividerView] frame];
    
    // Set up the main image frame
    CGRect mainImageFrame = {};
    mainImageFrame.size.width = contentViewWidth;
    mainImageFrame.size.height = mainImageFrame.size.width; // Keep it square
    mainImageFrame.origin = CGPointMake(0, CGRectGetMaxY(dividerViewFrame));
    
    // Apply the frames
    [[self mainImageView] setFrame:mainImageFrame];
    
	// Set frames of the hotspots
	[[super hotspotA] setBounds:CGRectMake(0, 0, 100, 100)];
	[[super hotspotB] setBounds:CGRectMake(0, 0, 100, 100)];
}

@end
