//
//  BetterTextField.m
//  Better
//
//  Created by Peter on 5/20/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BETextField.h"

@implementation BETextField

#pragma mark - Initialization
// Initialize from xib/storyboard
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
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
		[self setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:[[self font] pointSize]]];
	}
	return self;
}

#pragma mark - Positioning of TextField views
// Provides the CGRect for the text field to draw its left view
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
	// Return empty rect if the view doesn't exist (probably shouldn't happen)
	if(![self leftImageView])
        return [super leftViewRectForBounds:bounds];
	
	// Figure out where the view should go
	CGRect leftViewBounds;
	leftViewBounds.size.height = bounds.size.height / RATIO_TEXTFIELD_ICON_TO_HEIGHT;
	leftViewBounds.size.width = leftViewBounds.size.height;   // keep width and height the same
	leftViewBounds.origin.x = PADDING_TEXTFIELD_ICON;    // position at left
	leftViewBounds.origin.y = (bounds.size.height / 2) - (leftViewBounds.size.height / 2);
	
	return leftViewBounds;
}

// Provides the CGRect for the text field's right view
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
	// Return empty rect if the view doesn't exist (probably shouldn't happen)
	if(![self rightImageView])
        return [super rightViewRectForBounds:bounds];
	
	// Figure out where the view should go
	CGRect rightViewBounds;
	rightViewBounds.size.height = bounds.size.height / RATIO_TEXTFIELD_ICON_TO_HEIGHT;
	rightViewBounds.size.width = rightViewBounds.size.height;   // keep width and height the same
	rightViewBounds.origin.x = bounds.size.width - rightViewBounds.size.width - PADDING_TEXTFIELD_ICON; // position at right
	rightViewBounds.origin.y = (bounds.size.height / 2) - (rightViewBounds.size.height / 2);
	
	return rightViewBounds;
}

// Specify the bounds for the non-editing-mode of the text field
- (CGRect)textRectForBounds:(CGRect)bounds
{
	// Retrieve what the UITextField class would normally do
	CGRect textBounds = [super textRectForBounds:bounds];
	
	// Add padding to the left and subtract twice the same amount from the width
	textBounds.origin.x += PADDING_TEXTFIELD_ICON;
	textBounds.size.width -= 2 * PADDING_TEXTFIELD_ICON;
	
	return textBounds;
}

// Specify the bounds for the editing-mode of the text field
- (CGRect)editingRectForBounds:(CGRect)bounds
{
	// Retrieve what the UITextField class would normally do
	CGRect editingTextBounds = [super editingRectForBounds:bounds];
	
	// Add padding to the left and subtract twice the same amount from the width (for space on the right also)
	editingTextBounds.origin.x += PADDING_TEXTFIELD_ICON;
	editingTextBounds.size.width -= 2 * PADDING_TEXTFIELD_ICON;
	
	return editingTextBounds;
}

#pragma mark - Setting images as left/right views
- (void)setLeftViewToImageNamed:(NSString *)leftImageName
{
	// Retrieve the specified image; cancel if the image wasn't found
	UIImage *leftImage = [UIImage imageNamed:leftImageName];
	if(leftImage == nil)
		return; // image was not found
	
	// Create a UIImageView and set the correct properties/options
	UIImageView *imageView = [[UIImageView alloc] initWithImage:leftImage];
	[self setLeftViewMode:UITextFieldViewModeAlways];
	[self setLeftView:imageView];
	
	// Keep a weak reference to this ImageView
	[self setLeftImageView:imageView];
}

- (void)setRightViewToImageNamed:(NSString *)rightImageName
{
	// Retrieve the specified image; cancel if the image wasn't found
	UIImage *rightImage = [UIImage imageNamed:rightImageName];
	if(rightImage == nil)
		return; // image was not found
	
	// Create a UIImageView and set the correct properties/options
	UIImageView *imageView = [[UIImageView alloc] initWithImage:rightImage];
	[self setRightViewMode:UITextFieldViewModeAlways];
	[self setRightView:imageView];
	
	// Keep a weak reference to this ImageView
	[self setRightImageView:imageView];
}


#pragma mark - Updating leftView and rightView images
- (void)updateLeftViewImageToImageNamed:(NSString *)leftImageName
{
	// Check if the weak reference is nil or not
	if([self leftImageView] == nil)
		return;
	
	// If not nil, retrieve and update the image
	UIImage *leftImage = [UIImage imageNamed:leftImageName];
	if(leftImageName == nil)
		return; // image was not found
	
	// Update image
	[[self leftImageView] setImage:leftImage];
}

- (void)updateRightViewImageToImageNamed:(NSString *)rightImageName
{
	// Check if the weak reference is nil or not
	if([self rightImageView] == nil)
		return;
	
	// If not nil, retrieve and update the image
	UIImage *rightImage = [UIImage imageNamed:rightImageName];
	if(rightImageName == nil)
		return; // image was not found
	
	// Update image
	[[self rightImageView] setImage:rightImage];
}

@end
