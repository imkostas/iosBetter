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
    
    // Grayish background for imageview
    [[self mainImageView] setBackgroundColor:[UIColor grayColor]];
	
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
	// Set frames of the hotspots
	[[super hotspotA] setFrame:CGRectMake(10, 10, 100, 100)];
	[[super hotspotB] setFrame:CGRectMake(136, 70, 100, 100)];
	
	// Call super
	[super layoutSubviews];
}

@end
