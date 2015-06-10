//
//  BEGestureView.m
//  Better
//
//  Created by Peter on 6/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BETappableView.h"

@interface BETappableView ()

// Responds to taps from this class's UITapGestureRecognizer
- (void)tappedThis:(UITapGestureRecognizer *)gesture;

@end


@implementation BETappableView

#pragma mark - Initialization
// For initialization with storyboard
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		// Initialize class properties
		[self setTapGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedThis:)]];
		
		// Add gesture recognizer to myself
		[self addGestureRecognizer:[self tapGesture]];
	}
	return self;
}

// For initialization with storyboard
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		// Initialize class properties
		[self setTapGesture:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedThis:)]];
		
		// Add gesture recognizer to myself
		[self addGestureRecognizer:[self tapGesture]];
	}
	return self;
}

#pragma mark - Gesture recognizer target method
// Called when the tap gesture recognizer is active (user is tapping)
- (void)tappedThis:(UITapGestureRecognizer *)gesture
{
	// Check if nil
	if([self delegate] != nil)
		// Check if delegate accepts this method
		if([[self delegate] respondsToSelector:@selector(tappableViewTapped:withGesture:)])
			// Tell delegate that the user tapped on this UIView
			[[self delegate] tappableViewTapped:self withGesture:[self tapGesture]];
}

@end
