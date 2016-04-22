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

// Gesture recognizer properties
@property (strong, nonatomic) UIGestureRecognizer *pressHotspotARecognizer;
@property (strong, nonatomic) UIGestureRecognizer *pressHotspotBRecognizer;

// Gesture recognizer handlers for hotspots
- (void)pressedHotspotA:(UITapGestureRecognizer *)gesture;
- (void)pressedHotspotB:(UITapGestureRecognizer *)gesture;

// Shadow layer
@property (strong, nonatomic) CAShapeLayer *shadowLayer;

@end

@implementation FeedCell

#pragma mark - Initialization
- (void)awakeFromNib
{
    // Initialization code
    _hotspotGesturesEnabled = TRUE;

	// Load header nib
	// Tried to do something like this previously, couldn't figure it out, then saw the solution in Apple
	// sample code for using the camera (the "PhotoPicker" sample code). The method -instantiateWithOwner: returns an
	// NSArray of the objects in the nib file, but in this case we don't need to save them because all the
	// connections to the ui elements are created (due to specifying "self" for File's Owner) within loadNibNamed
    UINib *headerNib = [UINib nibWithNibName:@"FeedCellHeader" bundle:nil];
    [headerNib instantiateWithOwner:self options:nil];
    
    // Turn off automatic constraints and add the header as a subview
//    [[self headerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [[self shadowView] addSubview:[self headerView]];
    [[self contentView] addSubview:[self headerView]];
    
    // Set our background color (gray)
    [self setBackgroundColor:COLOR_GRAY_FEED];
	
	// Create hotspots;
	// ** Subclasses are responsible for setting their frames and adding them as subviews
	[self setHotspotA:[[BEHotspotView alloc] init]];
	[self setHotspotB:[[BEHotspotView alloc] init]];
	
	// Add tap gesture recognizers to the hotspots
    _pressHotspotARecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspotA:)];
    _pressHotspotBRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedHotspotB:)];
	[[self hotspotA] addGestureRecognizer:[self pressHotspotARecognizer]];
	[[self hotspotB] addGestureRecognizer:[self pressHotspotBRecognizer]];
	
	// Set up divider
	[[self dividerView] setBackgroundColor:COLOR_POST_DIVIDER];
	
	// Set up username, tags, and votes labels
	[[self usernameLabel] setTextColor:COLOR_FEED_HEADERTEXT];
	[[self numberOfVotesLabel] setTextColor:COLOR_FEED_HEADERTEXT];
    [[self tagsLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FEEDCELL_TAGSLABEL_FONT_SIZE]];
	[[self tagsLabel] setTextColor:COLOR_FEED_HASHTAGS_STOCK];
    [[self tagsLabel] setNumberOfLines:FEEDCELL_TAGSLABEL_MAX_NUM_LINES]; // max number of lines in the hashtag label
    
    // Set up shadow layer
    CALayer *contentViewLayer = [[self contentView] layer];
    [contentViewLayer setShadowColor:[[UIColor blackColor] CGColor]];
    [contentViewLayer setShadowOffset:CGSizeMake(0, 1)];
    [contentViewLayer setShadowOpacity:0.3];
    [contentViewLayer setShadowRadius:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Layout stuff
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Move the content inward
    [[self contentView] setFrame:CGRectInset([[self contentView] frame], FEEDCELL_INSET_LEFT, FEEDCELL_INSET_TOP)];
    
    // Get some values
    CGSize contentViewSize = [[self contentView] bounds].size;
    
    // Set the shadow path of the contentView
    CGPathRef shadowPath = CGPathCreateWithRect([[self contentView] bounds], NULL);
    CALayer *contentViewLayer = [[self contentView] layer];
    [contentViewLayer setShadowPath:shadowPath];
    CGPathRelease(shadowPath);

    // Frame for header view
    CGRect headerViewFrame;
    headerViewFrame.size.width = contentViewSize.width;
    headerViewFrame.size.height = FEEDCELL_HEADERVIEW_MIN_HEIGHT;
    headerViewFrame.origin.x = 0;
    headerViewFrame.origin.y = 0;
    
    // Frame for profile image
    CGRect profileImageViewFrame;
    profileImageViewFrame.size = CGSizeMake(FEEDCELL_PROFILEIMAGE_WIDTH, FEEDCELL_PROFILEIMAGE_HEIGHT);
    profileImageViewFrame.origin = CGPointMake(FEEDCELL_PROFILEIMAGE_LEFT, FEEDCELL_PROFILEIMAGE_TOP);
    // Set up the corner radius
    CALayer *profileLayer = [[self profileImageView] layer];
    [profileLayer setMasksToBounds:YES];
    [profileLayer setCornerRadius:(profileImageViewFrame.size.width / 2)];
    
    // Frame for 3-dots image view
    CGRect threeDotImageViewFrame;
    threeDotImageViewFrame.size = CGSizeMake(FEEDCELL_THREEDOTIMAGE_WIDTH, FEEDCELL_THREEDOTIMAGE_HEIGHT);
    threeDotImageViewFrame.origin.x = headerViewFrame.size.width - FEEDCELL_THREEDOTIMAGE_RIGHT - FEEDCELL_THREEDOTIMAGE_WIDTH;
    threeDotImageViewFrame.origin.y = profileImageViewFrame.origin.y; // Align top to prof. image top
    
    // Frame for hashtags label
    CGRect tagsLabelFrame;
    CGFloat desiredTagsLabelWidth = threeDotImageViewFrame.origin.x - FEEDCELL_THREEDOTIMAGE_LEFT - (profileImageViewFrame.origin.x + profileImageViewFrame.size.width + FEEDCELL_PROFILEIMAGE_RIGHT);
    
    // It seems to be faster to use -boundingRectWithSize: on an NSString than calling -sizeThatFits on the UILabel
    UIFont *tagsFont = [[self tagsLabel] font];
    NSDictionary *textAttrs = @{NSFontAttributeName:tagsFont};
    // We want to limit the bounding rect to the max. number of lines given by the tagsLabel
    CGSize maxTextSize = CGSizeMake(desiredTagsLabelWidth, [tagsFont lineHeight] * [[self tagsLabel] numberOfLines]);
    CGRect textRect = [[[self tagsLabel] text] boundingRectWithSize:maxTextSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:textAttrs
                                                                context:nil];
    tagsLabelFrame.size = CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
    tagsLabelFrame.origin.x = profileImageViewFrame.origin.x + profileImageViewFrame.size.width + FEEDCELL_PROFILEIMAGE_RIGHT;
    tagsLabelFrame.origin.y = profileImageViewFrame.origin.y;
    
    // Frame for username label
    CGRect usernameLabelFrame;
    usernameLabelFrame.size = [[self usernameLabel] sizeThatFits:CGSizeZero]; // Match its text size
    usernameLabelFrame.origin.x = profileImageViewFrame.origin.x + profileImageViewFrame.size.width + FEEDCELL_PROFILEIMAGE_RIGHT;
    usernameLabelFrame.origin.y = CGRectGetMaxY(tagsLabelFrame) + FEEDCELL_VERTSPACE_TAGS_TO_USERNAME;
    
    // If the bottom of username label is higher than the bottom of the profile image, slide the username down
    // (this occurs when the tags UILabel has only one line of text)
    CGFloat vertDifference = CGRectGetMaxY(profileImageViewFrame) - CGRectGetMaxY(usernameLabelFrame);
    if(vertDifference > 0)
        usernameLabelFrame.origin.y += ceilf(vertDifference);
    
    // Resize the headerView if there are three lines of text
    int lineMultiple = (int)roundf(textRect.size.height / [tagsFont lineHeight]);
    if(lineMultiple >= 3) // This means the username label has been pushed down by the tags label
        headerViewFrame.size.height += [tagsFont lineHeight]; // Make the header view taller to fit
    
    // Number of votes label
    CGRect numberVotesFrame;
    numberVotesFrame.size = [[self numberOfVotesLabel] sizeThatFits:CGSizeZero]; // Match its text size
    numberVotesFrame.origin.x = headerViewFrame.size.width - FEEDCELL_VOTESLABEL_RIGHT - numberVotesFrame.size.width;
    numberVotesFrame.origin.y = CGRectGetMaxY(usernameLabelFrame) - numberVotesFrame.size.height;
    
    // Checkmark
    CGRect checkmarkFrame;
    checkmarkFrame.size = CGSizeMake(FEEDCELL_CHECKMARK_WIDTH, FEEDCELL_CHECKMARK_HEIGHT);
    checkmarkFrame.origin.x = numberVotesFrame.origin.x - FEEDCELL_CHECKMARK_RIGHT - checkmarkFrame.size.width;
    checkmarkFrame.origin.y = numberVotesFrame.origin.y - checkmarkFrame.size.height / 2 + numberVotesFrame.size.height / 2;
    
    // 3-dot button
    CGRect threeDotButtonFrame;
    threeDotButtonFrame.size.width = headerViewFrame.size.width / 4;
    threeDotButtonFrame.size.height = headerViewFrame.size.height;
    threeDotButtonFrame.origin.x = headerViewFrame.size.width - threeDotButtonFrame.size.width;
    threeDotButtonFrame.origin.y = 0;
    
    // Frame for divider view
    CGRect dividerViewFrame;
    dividerViewFrame.size.width = contentViewSize.width;
    dividerViewFrame.size.height = FEEDCELL_DIVIDERVIEW_HEIGHT;
    dividerViewFrame.origin.x = 0;
    dividerViewFrame.origin.y = headerViewFrame.origin.y + headerViewFrame.size.height;
    
    // Apply the new frames
    [[self headerView] setFrame:headerViewFrame];
    [[self profileImageView] setFrame:profileImageViewFrame];
    [[self threeDotImageView] setFrame:threeDotImageViewFrame];
    [[self tagsLabel] setFrame:tagsLabelFrame];
    [[self usernameLabel] setFrame:usernameLabelFrame];
    [[self numberOfVotesLabel] setFrame:numberVotesFrame];
    [[self checkmarkImageView] setFrame:checkmarkFrame];
    [[self threeDotButton] setFrame:threeDotButtonFrame];
    [[self dividerView] setFrame:dividerViewFrame];
}

// Called when the cell wants to determine its layout
//- (void)layoutSubviews
//{
//	// Call all the layout stuff first, so the shadow is applied to the correct bounds
//	[super layoutSubviews];
//	
//	if(!_alreadyLaidOutSubviews)
//	{
//		/** Generate constraints to place the header in the area above the divider.
//		 We want it to hug the left, right, and top of the shadowView, and be aligned with the top of
//		 the divider **/
//		NSArray *headerHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[header]-0-|"
//																			options:NSLayoutFormatDirectionLeadingToTrailing
//																			metrics:nil
//																			  views:@{@"header":[self headerView]}];
//		
//		NSArray *headerVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[header]-0-[divider]"
//																		  options:NSLayoutFormatDirectionLeadingToTrailing
//																		  metrics:nil
//																			views:@{@"header":[self headerView],
//																					@"divider":[self dividerView]}];
//		
//		[[self shadowView] addConstraints:headerHorizontal];
//		[[self shadowView] addConstraints:headerVertical];
//		
//		/** Run auto-layout on this cell before we start applying the CALayer effects **/
//		[[self contentView] setNeedsLayout];
//		[[self contentView] layoutIfNeeded];
//
//		/** Set up the label's # of lines and preferred max width (this seems to be better than hard-coding
//		 a value in the .xib -- thank you Stack overflow) **/
////		NSLog(@"preferred width: %.1f", [self.headerView.tagsLabel preferredMaxLayoutWidth]);
//		[[self tagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([self.tagsLabel bounds])];
//		[[self tagsLabel] setNumberOfLines:3];
//        
//        // Set up shadow for the first time
//        CALayer *layer = [[self shadowView] layer];
//        CGPathRef boundsPath = [[UIBezierPath bezierPathWithRect:[[self shadowView] bounds]] CGPath];
//        [layer setShadowPath:boundsPath];
//        [layer setShadowOffset:CGSizeMake(0, 1)];
//        [layer setShadowRadius:2];
//        [layer setShadowOpacity:0.3];
//        
//        // Set up profile picture layer properties
//        CALayer *profileLayer = [self.profileImageView layer];
//        [profileLayer setMasksToBounds:YES];
//        [profileLayer setCornerRadius:CGRectGetWidth([self.profileImageView bounds]) / 2];
////		[profileLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
////		[profileLayer setShouldRasterize:YES];
//		
//		_alreadyLaidOutSubviews = TRUE;
//	}
//    else // Already laid everything out the first time
//    {
//        /** Run auto-layout on this cell before we start applying the CALayer effects **/
//        [[self contentView] setNeedsLayout];
//        [[self contentView] layoutIfNeeded];
//        
//        // Set up the cell's shadow again (this is outside the run-once layout if() above because the UITableView
//        // that this cell is a part of may change the height of this cell (e.g. in response to a large hashtag string)
//        // so, the shadow may need to be updated more than once
//        CALayer *layer = [[self shadowView] layer];
//        CGPathRef boundsPath = [[UIBezierPath bezierPathWithRect:[[self shadowView] bounds]] CGPath];
//        [layer setShadowPath:boundsPath];
//    }
//}

#pragma mark - Gesture handling
- (void)pressedHotspotA:(UITapGestureRecognizer *)gesture
{
//	NSLog(@"You pressed on hotspot A, %@", self);
    if([self delegate])
        [[self delegate] hotspotWasTappedForFeedCell:self withVoteChoice:VoteChoiceA];
}

- (void)pressedHotspotB:(UITapGestureRecognizer *)gesture
{
//	NSLog(@"You pressed on hotspot B, %@", self);
    if([self delegate])
        [[self delegate] hotspotWasTappedForFeedCell:self withVoteChoice:VoteChoiceB];
}

#pragma mark - Custom setters
- (void)setHotspotGesturesEnabled:(BOOL)hotspotGesturesEnabled
{
    [[self pressHotspotARecognizer] setEnabled:hotspotGesturesEnabled];
    [[self pressHotspotBRecognizer] setEnabled:hotspotGesturesEnabled];
    
    // Save the value
    _hotspotGesturesEnabled = hotspotGesturesEnabled;
}

#pragma mark - Button handling
- (IBAction)pressedThreeDotButton:(id)sender
{
//    NSLog(@"pressed on 3-dot button for post ID %i", [[self postObject] postID]);
    
    // Tell the delegate that the 3-dot button was pressed
    if([self delegate])
        [[self delegate] threeDotButtonWasTappedForFeedCell:self];
}

@end
