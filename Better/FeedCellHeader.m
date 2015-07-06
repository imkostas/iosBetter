//
//  FeedCellHeader.m
//  CustomTableViews
//
//  Created by Peter on 6/30/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedCellHeader.h"

@implementation FeedCellHeader

// xib/storyboard initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initializeUI];
	}
	
	return self;
}

// Programmatic initialization
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self initializeUI];
	}
	
	return self;
}

// Initializes and sets properties for UI elements
- (void)initializeUI
{
	/** Create UI elements **/
	/** We need to turn off the autoresizing mask translation so we can use our own constraints **/
	
	// Profile image
	UIImageView *profilePic = [[UIImageView alloc] init];
	[profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	// Hashtag UILabel
	UILabel *hashtags = [[UILabel alloc] init];
	[hashtags setTranslatesAutoresizingMaskIntoConstraints:NO];
	[hashtags setFont:[UIFont systemFontOfSize:15]];
	[hashtags setLineBreakMode:NSLineBreakByWordWrapping];
	[hashtags setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	[hashtags setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
	
	// Username UILabel
	UILabel *user = [[UILabel alloc] init];
	[user setTranslatesAutoresizingMaskIntoConstraints:NO];
	[user setFont:[UIFont boldSystemFontOfSize:12]];
	
	// 3-dot button
	UIImageView *threeDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ThreeDots"]];
	[threeDot setTranslatesAutoresizingMaskIntoConstraints:NO];
	[threeDot setContentMode:UIViewContentModeScaleAspectFit];
	
	// Checkmark
	UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
	[checkmark setTranslatesAutoresizingMaskIntoConstraints:NO];
	[checkmark setContentMode:UIViewContentModeScaleToFill];
	
	// Votes label
	UILabel *votesLabel = [[UILabel alloc] init];
	[votesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[votesLabel setFont:[UIFont boldSystemFontOfSize:13]];
	[votesLabel setTextAlignment:NSTextAlignmentRight];
	
	/** Save all references **/
	[self setProfileImageView:profilePic];
	[self setTagsLabel:hashtags];
	[self setUsernameLabel:user];
	[self setNumberOfVotesLabel:votesLabel];
	[self setThreeDotMenuButton:threeDot];
	[self setCheckmarkImage:checkmark];
	
	/** Add all UI elements as subviews (needs to happen *before* creating constraints) **/
	[self addSubview:[self profileImageView]];
	[self addSubview:[self tagsLabel]];
	[self addSubview:[self usernameLabel]];
	[self addSubview:[self numberOfVotesLabel]];
	[self addSubview:[self threeDotMenuButton]];
	[self addSubview:[self checkmarkImage]];
	
	/*** Create constraints ***/
#define MARGIN_TINY 2
#define MARGIN 8
#define MARGIN_DOUBLE 16
#define MARGIN_PROFILE 19
#define WIDTH_PROFILE 58
#define WIDTH_3DOTMENU 4
#define WIDTH_CHECKMARK 20
#define VERTICAL_SPACE_HASHTAGS_TO_USER 10
	
	/** Profile image view **/
	NSLayoutConstraint *profileDimension = [NSLayoutConstraint constraintWithItem:[self profileImageView]
																		attribute:NSLayoutAttributeWidth
																		relatedBy:NSLayoutRelationEqual
																		   toItem:nil
																		attribute:NSLayoutAttributeNotAnAttribute
																	   multiplier:1 constant:WIDTH_PROFILE];
	
	NSLayoutConstraint *profileWidthHeight = [NSLayoutConstraint constraintWithItem:[self profileImageView]
																		  attribute:NSLayoutAttributeWidth
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self profileImageView]
																		  attribute:NSLayoutAttributeHeight
																		 multiplier:1 constant:0];
	
	//	NSLayoutConstraint *profileCenterYAlign = [NSLayoutConstraint constraintWithItem:[self profileImageView]
	//																		   attribute:NSLayoutAttributeCenterY
	//																		   relatedBy:NSLayoutRelationEqual
	//																			  toItem:self
	//																		   attribute:NSLayoutAttributeCenterY
	//																		  multiplier:1 constant:0];
	
	NSLayoutConstraint *profileTop = [NSLayoutConstraint constraintWithItem:[self profileImageView]
																  attribute:NSLayoutAttributeTop
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self
																  attribute:NSLayoutAttributeTop
																 multiplier:1 constant:MARGIN_PROFILE];
	
	NSLayoutConstraint *profileLeading = [NSLayoutConstraint constraintWithItem:[self profileImageView]
																	  attribute:NSLayoutAttributeLeading
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:self
																	  attribute:NSLayoutAttributeLeading
																	 multiplier:1 constant:MARGIN];
	
	NSLayoutConstraint *profileTrailingToTags = [NSLayoutConstraint constraintWithItem:[self tagsLabel]
																			 attribute:NSLayoutAttributeLeading
																			 relatedBy:NSLayoutRelationEqual
																				toItem:[self profileImageView]
																			 attribute:NSLayoutAttributeTrailing
																			multiplier:1 constant:MARGIN_DOUBLE];
	
	NSLayoutConstraint *profileTrailingToUser = [NSLayoutConstraint constraintWithItem:[self usernameLabel]
																			 attribute:NSLayoutAttributeLeading
																			 relatedBy:NSLayoutRelationEqual
																				toItem:[self profileImageView]
																			 attribute:NSLayoutAttributeTrailing
																			multiplier:1 constant:MARGIN_DOUBLE];
	/** Hashtags **/
	NSLayoutConstraint *tagsTopToProfile = [NSLayoutConstraint constraintWithItem:[self tagsLabel]
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self profileImageView]
																		attribute:NSLayoutAttributeTop
																	   multiplier:1 constant:0];
	
	NSLayoutConstraint *tagsBottomToUser = [NSLayoutConstraint constraintWithItem:[self usernameLabel]
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationGreaterThanOrEqual
																		   toItem:[self tagsLabel]
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1 constant:VERTICAL_SPACE_HASHTAGS_TO_USER];
	
	NSLayoutConstraint *tagsTrailingTo3Dot = [NSLayoutConstraint constraintWithItem:[self threeDotMenuButton]
																		  attribute:NSLayoutAttributeLeading
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self tagsLabel]
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1 constant:MARGIN_DOUBLE];
	
	/** 3-dot button **/
	NSLayoutConstraint *threeDotWidth = [NSLayoutConstraint constraintWithItem:[self threeDotMenuButton]
																	 attribute:NSLayoutAttributeWidth
																	 relatedBy:NSLayoutRelationEqual
																		toItem:nil
																	 attribute:NSLayoutAttributeNotAnAttribute
																	multiplier:1 constant:WIDTH_3DOTMENU];
	
	NSLayoutConstraint *threeDotTop = [NSLayoutConstraint constraintWithItem:[self threeDotMenuButton]
																   attribute:NSLayoutAttributeTop
																   relatedBy:NSLayoutRelationEqual
																	  toItem:[self tagsLabel]
																   attribute:NSLayoutAttributeTop
																  multiplier:1 constant:0];
	
	NSLayoutConstraint *threeDotTrailing = [NSLayoutConstraint constraintWithItem:self
																		attribute:NSLayoutAttributeTrailing
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self threeDotMenuButton]
																		attribute:NSLayoutAttributeTrailing
																	   multiplier:1 constant:MARGIN];
	
	/** Username label **/
	NSLayoutConstraint *userBottom = [NSLayoutConstraint constraintWithItem:[self usernameLabel]
																  attribute:NSLayoutAttributeBottom
																  relatedBy:NSLayoutRelationEqual
																	 toItem:[self profileImageView]
																  attribute:NSLayoutAttributeBottom
																 multiplier:1 constant:0];
	[userBottom setPriority:UILayoutPriorityDefaultLow];
	// ^^ We want to break this constraint when the hashtags text grows larger
	
	/** Checkmark **/
	NSLayoutConstraint *checkmarkWidthHeight = [NSLayoutConstraint constraintWithItem:[self checkmarkImage]
																			attribute:NSLayoutAttributeWidth
																			relatedBy:NSLayoutRelationEqual
																			   toItem:[self checkmarkImage]
																			attribute:NSLayoutAttributeHeight
																		   multiplier:1 constant:0];
	
	NSLayoutConstraint *checkmarkWidth = [NSLayoutConstraint constraintWithItem:[self checkmarkImage]
																	  attribute:NSLayoutAttributeWidth
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:nil
																	  attribute:NSLayoutAttributeNotAnAttribute
																	 multiplier:1 constant:WIDTH_CHECKMARK];
	
	NSLayoutConstraint *checkmarkTrailing = [NSLayoutConstraint constraintWithItem:[self numberOfVotesLabel]
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:[self checkmarkImage]
																		 attribute:NSLayoutAttributeTrailing
																		multiplier:1 constant:MARGIN_TINY];
	
	NSLayoutConstraint *checkmarkCenterY = [NSLayoutConstraint constraintWithItem:[self checkmarkImage]
																		attribute:NSLayoutAttributeCenterY
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self numberOfVotesLabel]
																		attribute:NSLayoutAttributeCenterY
																	   multiplier:1 constant:0];
	
	NSLayoutConstraint *checkmarkEqualHeight = [NSLayoutConstraint constraintWithItem:[self checkmarkImage]
																			attribute:NSLayoutAttributeHeight
																			relatedBy:NSLayoutRelationEqual
																			   toItem:[self numberOfVotesLabel]
																			attribute:NSLayoutAttributeHeight
																		   multiplier:1 constant:0];
	
	/** Number of votes label **/
	NSLayoutConstraint *votesTrailing = [NSLayoutConstraint constraintWithItem:self
																	 attribute:NSLayoutAttributeTrailing
																	 relatedBy:NSLayoutRelationEqual
																		toItem:[self numberOfVotesLabel]
																	 attribute:NSLayoutAttributeTrailing
																	multiplier:1 constant:MARGIN];
	
	NSLayoutConstraint *votesCenterY = [NSLayoutConstraint constraintWithItem:[self numberOfVotesLabel]
																	attribute:NSLayoutAttributeCenterY
																	relatedBy:NSLayoutRelationEqual
																	   toItem:[self usernameLabel]
																	attribute:NSLayoutAttributeCenterY
																   multiplier:1 constant:0];
	
	/** Finally add all the constraints **/
	[self addConstraints:@[profileDimension,
						   profileWidthHeight,
						   profileTop,
//						   profileCenterYAlign,
						   profileLeading,
						   profileTrailingToTags,
						   profileTrailingToUser,
						   tagsTopToProfile,
						   tagsBottomToUser,
						   tagsTrailingTo3Dot,
						   threeDotWidth,
						   threeDotTop,
						   threeDotTrailing,
						   userBottom,
						   checkmarkWidthHeight,
						   checkmarkTrailing,
						   checkmarkCenterY,
						   checkmarkEqualHeight,
						   checkmarkWidth,
						   votesTrailing,
						   votesCenterY]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
