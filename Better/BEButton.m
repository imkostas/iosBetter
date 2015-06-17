//
//  BEButton.m
//  Better
//
//  Created by Peter on 6/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEButton.h"

@implementation BEButton

// Initialize from xib/storyboard
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		// Set the font of the button's title label to Raleway, keeping the same font size
		[[self titleLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[[self titleLabel] font] pointSize]]];
	}
	return self;
}

// Initialize programmatically
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Set the font of the button's title label to Raleway, keeping the same font size
		[[self titleLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[[self titleLabel] font] pointSize]]];
	}
	return self;
}

@end
