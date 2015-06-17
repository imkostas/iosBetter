//
//  BELabel.m
//  Better
//
//  Created by Peter on 6/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BELabel.h"

@implementation BELabel

// Initialize from xib/storyboard
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		// Set font to Raleway, with the existing font size
		[self setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]]];
	}
	return self;
}

// Initialize programmatically
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Set font to Raleway, with the existing font size
		[self setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]]];
	}
	return self;
}

@end
