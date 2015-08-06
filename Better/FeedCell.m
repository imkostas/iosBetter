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
- (void)pressedHotspotA:(UITapGestureRecognizer *)gesture;
- (void)pressedHotspotB:(UITapGestureRecognizer *)gesture;

@end

@implementation FeedCell

#pragma mark - Initialization
- (void)awakeFromNib
{
    // Initialization code
	
	// Load header nib
	// Tried to do something like this previously, couldn't figure it out, then saw the solution in Apple
	// sample code for using the camera (the "PhotoPicker" sample code). The method -instantiateWithOwner: returns an
	// NSArray of the objects in the nib file, but in this case we don't need to save them because all the
	// connections to the ui elements are created (due to specifying "self" for File's Owner) within loadNibNamed
    UINib *headerNib = [UINib nibWithNibName:@"FeedCellHeader" bundle:nil];
    [headerNib instantiateWithOwner:self options:nil];
    
    // Turn off automatic constraints and add the header as a subview
    [[self headerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self shadowView] addSubview:[self headerView]];
	
	// Create hotspots;
	// ** Subclasses are responsible for setting their frames and adding them as subviews
	[self setHotspotA:[[BEHotspotView alloc] init]];
	[self setHotspotB:[[BEHotspotView alloc] init]];
	
	// Add tap gesture recognizers to the hotspots
	[[self hotspotA] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspotA:)]];
	[[self hotspotB] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspotB:)]];
	
	// Set up divider
	[[self dividerView] setBackgroundColor:COLOR_POST_DIVIDER];
	
	// Set up username, tags, and votes labels
	[[self usernameLabel] setTextColor:COLOR_FEED_HEADERTEXT];
	[[self numberOfVotesLabel] setTextColor:COLOR_FEED_HEADERTEXT];
	[[self tagsLabel] setTextColor:COLOR_FEED_HASHTAGS_STOCK];
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
		/** Generate constraints to place the header in the area above the divider.
		 We want it to hug the left, right, and top of the shadowView, and be aligned with the top of
		 the divider **/
		NSArray *headerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[header]-0-|"
																			options:NSLayoutFormatDirectionLeadingToTrailing
																			metrics:nil
																			  views:@{@"header":[self headerView]}];
		
		NSArray *headerVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[header]-0-[divider]"
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
//		NSLog(@"preferred width: %.1f", [self.headerView.tagsLabel preferredMaxLayoutWidth]);
		[[self tagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([self.tagsLabel bounds])];
		[[self tagsLabel] setNumberOfLines:3];
        
        // Set up shadow for the first time
        CALayer *layer = [[self shadowView] layer];
        CGPathRef boundsPath = [[UIBezierPath bezierPathWithRect:[[self shadowView] bounds]] CGPath];
        [layer setShadowPath:boundsPath];
        [layer setShadowOffset:CGSizeMake(0, 1)];
        [layer setShadowRadius:2];
        [layer setShadowOpacity:0.3];
        
        // Set up profile picture layer properties
        CALayer *profileLayer = [self.profileImageView layer];
        [profileLayer setMasksToBounds:YES];
        [profileLayer setCornerRadius:CGRectGetWidth([self.profileImageView bounds]) / 2];
//		[profileLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
//		[profileLayer setShouldRasterize:YES];
		
		_alreadyLaidOutSubviews = TRUE;
	}
    else // Already laid everything out the first time
    {
        /** Run auto-layout on this cell before we start applying the CALayer effects **/
//        [[self contentView] setNeedsLayout];
//        [[self contentView] layoutIfNeeded];
        
        // Set up the cell's shadow again (this is outside the run-once layout if() above because the UITableView
        // that this cell is a part of may change the height of this cell (e.g. in response to a large hashtag string)
        // so, the shadow may need to be updated more than once
        CALayer *layer = [[self shadowView] layer];
        CGPathRef boundsPath = [[UIBezierPath bezierPathWithRect:[[self shadowView] bounds]] CGPath];
        [layer setShadowPath:boundsPath];
    }
}

#pragma mark - Gesture handling
- (void)pressedHotspotA:(UITapGestureRecognizer *)gesture
{
	NSLog(@"You pressed on hotspot A, %@", self);
}

- (void)pressedHotspotB:(UITapGestureRecognizer *)gesture
{
	NSLog(@"You pressed on hotspot B, %@", self);
}

#pragma mark - Button handling
- (IBAction)pressedThreeDotButton:(id)sender
{
    NSLog(@"pressed on 3-dot button for post ID %i", [[self postObject] postID]);
    
    // Tell the delegate that the 3-dot button was pressed
    if([self delegate])
        [[self delegate] threeDotButtonWasTappedForFeedCell:self];
}

@end
