//
//  BELabel.m
//  Better
//
//  Created by Peter on 6/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BELabel.h"

@interface BELabel ()

// Hold the default font to revert back to if necessary
@property (strong, nonatomic) UIFont *defaultFont;

@end

@implementation BELabel

// Initialize from xib/storyboard
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		// Set font to Raleway, with the existing font size
		UIFont *newFont = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]];
		[self setFont:newFont];
		[self setDefaultFont:newFont];
		_emphasized = FALSE;
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
		UIFont *newFont = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]];
		[self setFont:newFont];
		[self setDefaultFont:newFont];
		_emphasized = FALSE;
	}
	return self;
}

// Go to default font
- (void)revertToDefaultFont
{
	[self setFont:[self defaultFont]];
}

// Set bold/unbold
- (void)setEmphasized:(BOOL)emphasized
{
	if(emphasized)
	{
		// Set font to Raleway bold, with the existing font size
		UIFont *newFont = [UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:[[self font] pointSize]];
		[self setFont:newFont];
		[self setAlpha:1];
		_emphasized = TRUE;
	}
	else
	{
		// Set font to Raleway, with the existing font size
		UIFont *newFont = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]];
		[self setFont:newFont];
		[self setAlpha:0.6];
		_emphasized = FALSE;
	}
}

@end
