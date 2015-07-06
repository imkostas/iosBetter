//
//  FeedCell.m
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedCell.h"

@interface FeedCell ()

// Bool to remember if we already called -setNeedsLayout and -layoutIfNeeded on the contentView (this
// forces auto layout to do its stuff)
@property (nonatomic) BOOL alreadyLaidOutSubviews;

// Gesture recognizer handlers for hotspots
- (void)pressedHotspot1:(UITapGestureRecognizer *)gesture;
- (void)pressedHotspot2:(UITapGestureRecognizer *)gesture;

@end

@implementation FeedCell

#pragma mark - Initialization
- (void)awakeFromNib
{
    // Initialization code
	
	// Create header view
	[self setHeaderView:[[FeedCellHeader alloc] init]];
	
	// Create hotspots;
	// ** Subclasses are responsible for setting their frames and adding them as subviews
	[self setHotspot1:[[BEHotspotView alloc] init]];
	[self setHotspot2:[[BEHotspotView alloc] init]];
	
	// Add tap gesture recognizers to the hotspots
	[[self hotspot1] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspot1:)]];
	[[self hotspot2] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspot2:)]];
	
	// Set up divider
	[[self dividerView] setBackgroundColor:COLOR_POST_DIVIDER];
	
	// Set up username and votes labels
	[self.headerView.usernameLabel setTextColor:COLOR_DARKISH_GRAY];
	[self.headerView.numberOfVotesLabel setTextColor:COLOR_DARKISH_GRAY];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Layout stuff
// Called when the cell wants to determine its layout
- (void)layoutSubviews
{
	// Call all the layout stuff first, so the shadow is applied to the correct bounds
	[super layoutSubviews];
	
	if(!_alreadyLaidOutSubviews)
	{
		/** Turn off automatic constraints and add the header as a subview **/
		[[self headerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self shadowView] addSubview:[self headerView]];

		/** Generate constraints to place the header in the area above the divider.
		 We want it to hug the left, right, and top of the shadowView, and be aligned with the top of
		 the divider **/
		NSArray *headerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[header]-(0)-|"
																			options:NSLayoutFormatDirectionLeadingToTrailing
																			metrics:nil
																			  views:@{@"header":[self headerView]}];
		
		NSArray *headerVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[header]-(0)-[divider]"
																		  options:NSLayoutFormatDirectionLeadingToTrailing
																		  metrics:nil
																			views:@{@"header":[self headerView],
																					@"divider":[self dividerView]}];
		
		[[self shadowView] addConstraints:headerHorizontal];
		[[self shadowView] addConstraints:headerVertical];
		
		/** Run auto-layout on this cell before we start applying the CALayer effects **/
		[[self contentView] setNeedsLayout];
		[[self contentView] layoutIfNeeded];

		/** Set up the label's # of lines and preferred max width (this seems to be better than hard-coding
		 a value in the .xib -- thank you Stack overflow) **/
		[self.headerView.tagsLabel setPreferredMaxLayoutWidth:CGRectGetWidth([self.headerView.tagsLabel bounds])];
		[self.headerView.tagsLabel setNumberOfLines:3];
//		NSLog(@"preferred width: %.1f", [self.headerView.tagsLabel preferredMaxLayoutWidth]);
		
		/** Set up the cell's shadow **/
		CALayer *layer = [[self shadowView] layer];
		CGPathRef boundsPath = [[UIBezierPath bezierPathWithRect:[[self shadowView] bounds]] CGPath];
		
		[layer setShadowPath:boundsPath];
		[layer setShadowOffset:CGSizeMake(0, 1)];
		[layer setShadowRadius:2];
		[layer setShadowOpacity:0.3];
//		[layer setRasterizationScale:[[UIScreen mainScreen] scale]];
//		[layer setShouldRasterize:YES];
//
//		/** Set up profile picture layer properties **/
		CALayer *profileLayer = [self.headerView.profileImageView layer];
		[profileLayer setMasksToBounds:YES];
		[profileLayer setCornerRadius:CGRectGetWidth([self.headerView.profileImageView bounds]) / 2];
//		[profileLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//		[profileLayer setShouldRasterize:YES];
		
		_alreadyLaidOutSubviews = TRUE;
	}
}

#pragma mark - Gesture handling
- (void)pressedHotspot1:(UITapGestureRecognizer *)gesture
{
	NSLog(@"You pressed on hotspot 1, %@", self);
}

- (void)pressedHotspot2:(UITapGestureRecognizer *)gesture
{
	NSLog(@"You pressed on hotspot 2, %@", self);
}

@end
