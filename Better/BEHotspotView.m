//
//  BEHotspotView.m
//  CustomTableViews
//
//  Created by Peter on 7/2/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "BEHotspotView.h"

@interface BEHotspotView ()

// The background image for this view (the transparent, unfilled hotspot image)
@property (strong, nonatomic) UIImageView *backgroundImageView;

// UILabel for showing the percentage text
@property (strong, nonatomic) UILabel *percentageLabel;

@end

@implementation BEHotspotView

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		/** Initialize colors, background image, UI **/
		
		_selected = FALSE; // Unselected by default
		
		// Initialize
		[self setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hotspot"]]];
		[self setPercentageLabel:[[UILabel alloc] init]];
		
		// Configure properties
//		[[self percentageLabel] setBackgroundColor:[UIColor blueColor]];
		[[self percentageLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self percentageLabel] setTextColor:[UIColor colorWithWhite:0.88 alpha:1]];
		
		[[[self backgroundImageView] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
		[[[self backgroundImageView] layer] setShouldRasterize:YES];
		
		// Add all subviews
		[self addSubview:[self backgroundImageView]];
		[self addSubview:[self percentageLabel]];
	}
	
	return self;
}

#pragma mark - View's layout
- (void)layoutSubviews
{
	/** Set up the background image, etc. **/
	
	// Background image
	[[self backgroundImageView] setFrame:[self bounds]];
	
	// Percentage label
	CGRect labelFrame;
	labelFrame.size.width = CGRectGetWidth([self bounds]);
	labelFrame.size.height = CGRectGetHeight([self bounds]) / 3;
	labelFrame.origin.x = 0;
	labelFrame.origin.y = (CGRectGetHeight([self bounds]) / 2) - (labelFrame.size.height / 2);
	[[self percentageLabel] setFrame:labelFrame];
	
	// Call super
	[super layoutSubviews];
}

#pragma mark - Setting properties
- (void)setPercentageValue:(float)percentageValue
{
	// Keep within zero and one
	if(percentageValue < 0) percentageValue = 0;
	if(percentageValue > 1) percentageValue = 1;
	
	/** Update the UILabel **/
	
	// Convert the value to a string with a number between 0 and 100
	NSString *percent = [NSString stringWithFormat:@"%i", (int)roundf(percentageValue * 100)];
	
	// The number should have large text while the "%" should have smaller text, so create an attributed
	// string with the correct ranges
	
	// For the number
	NSRange firstRange;
	firstRange.location = 0;
	firstRange.length = [percent length];
	
	// For the "%"
	NSRange secondRange;
	secondRange.location = [percent length];
	secondRange.length = 1;
	
	// Create the attributed string
	NSMutableAttributedString *percentageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", percent]];
	[percentageString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26] range:firstRange];
	[percentageString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:secondRange];
	
	// Apply it to the label
	[[self percentageLabel] setAttributedText:percentageString];
	
	// Finally record the new value
	_percentageValue = percentageValue;
}

#pragma mark - Custom drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    /** Drawing code **/
//	
//	// Get reference to the graphics context
//	CGContextRef graphics = UIGraphicsGetCurrentContext();
//	
//	// Draw a circle
//	CGContextSetFillColorWithColor(graphics, [[UIColor colorWithRed:170/255. green:0 blue:0 alpha:1] CGColor]);
//	CGContextFillEllipseInRect(graphics, [self bounds]);
//}

@end
