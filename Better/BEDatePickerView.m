//
//  BEDatePicker.m
//  PickerTest
//
//  Created by Peter on 6/1/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEDatePickerView.h"

@interface BEDatePickerView ()

// Private method that responds to the value of the picker being changed (calls the delegate and gives
// it a pointer to this instance)
- (void)valueChanged;

// Sub-objects of this view
@property (strong, nonatomic) UIView *transparencyView;
@property (strong, nonatomic) UIDatePicker *picker;
@property (strong, nonatomic) UIView *topBar;
@property (strong, nonatomic) UIButton *dismissButton;

// Keeps track of calls to -show and -dismiss, so this view can't be repeatedly shown without dismissing it
// (and vice versa)
@property (nonatomic) BOOL visible;

@end

@implementation BEDatePickerView

#pragma mark - View initialization and layout

// Called when this UIView is created programmatically (not storyboard)
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		// Turn off automatic constraints for ourselves--it's the responsibility of the superview to
		// generate the correct constraints
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		// Initialize local vars
		[self setVisible:NO]; // Not visible right now
		
		// Initialize all sub-objects of this view (top bar, button, picker, etc..)
		UIView *transparencyView = [[UIView alloc] init];
		UIDatePicker *picker = [[UIDatePicker alloc] init];
		UIView *bar = [[UIView alloc] init];
		UILabel *barLabel = [[UILabel alloc] init];
		UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																			  action:@selector(dismiss)];
		
		// Keep references to them
		[self setTransparencyView:transparencyView];
		[self setPicker:picker];
		[self setTopBar:bar];
		[self setLabel:barLabel];
		[self setDismissButton:dismissBtn];
		
		// Transparency view properties
		[[self transparencyView] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self transparencyView] setBackgroundColor:COLOR_PICKER_TRANSPARENCY];
		[[self transparencyView] setAlpha:0]; // Hide it, for now
		[[self transparencyView] addGestureRecognizer:tap]; // Call -dismiss when tap occurs
		
		// DatePicker properties
		[[self picker] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self picker] setBackgroundColor:COLOR_PICKER_BACKGROUND];
		[[self picker] setDatePickerMode:UIDatePickerModeDate];
		[[self picker] addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
		
		// Bar properties
		[[self topBar] setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		// Label properties
		[[self label] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self label] setFont:[UIFont boldSystemFontOfSize:16]];
//		[[self label] setText:@"Your birthdate"];
		
		// Button properties
		[[self dismissButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
		[[self dismissButton] setTitle:@"Done" forState:UIControlStateNormal];
		[[self dismissButton] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[[[self dismissButton] titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
		[[self dismissButton] addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		
		// Add button and label to the top bar
		[[self topBar] addSubview:[self label]];
		[[self topBar] addSubview:[self dismissButton]];
		[[self topBar] setBackgroundColor:COLOR_PICKER_TOPBAR];
		
		// Add transparency view, picker, and top bar to the main view
		[self addSubview:[self transparencyView]];
		[self addSubview:[self topBar]];
		[self addSubview:[self picker]];
		
		// Generate the constraints
		
		////////////////////////////////////////////////////
		////// Set up constraints for the transparent view:
		// Lock all four sides to its superview (this class).
		
		// Maps a string to a view for use in generating constraints
		NSDictionary *viewDictionaryTransparency = @{@"tView": [self transparencyView]};
		
		NSArray *transparencyViewHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tView]-0-|"
																					  options:NSLayoutFormatDirectionLeadingToTrailing
																					  metrics:nil
																						views:viewDictionaryTransparency];
		
		NSArray *transparencyViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tView]-0-|"
																					options:NSLayoutFormatDirectionLeadingToTrailing
																					metrics:nil
																					  views:viewDictionaryTransparency];
		
		/////////////////////////////////////
		////// Set up constraints for picker:
		NSLayoutConstraint *pickerLeading = [NSLayoutConstraint constraintWithItem:[self picker]
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1
																		  constant:0];
		NSLayoutConstraint *pickerTrailing = [NSLayoutConstraint constraintWithItem:[self picker]
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1
																		   constant:0];
		NSLayoutConstraint *pickerBottom = [NSLayoutConstraint constraintWithItem:[self picker]
																		attribute:NSLayoutAttributeBottom
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1
																		 constant:[[self picker] frame].size.height + HEIGHT_PICKER_TOPBAR];
		[self setPickerShowHideConstraint:pickerBottom]; // Keep a reference to this constraint for showing/
														 // hiding.
														// (+) constant moves picker, bar downard
														// (starts off hidden)
		////////////////////////////////
		////// Constraints for top bar:
		// Attached to left side with no extra space
		NSLayoutConstraint *topBarLeading = [NSLayoutConstraint constraintWithItem:[self topBar]
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1
																		  constant:0];
		// Attached to right side with no extra space
		NSLayoutConstraint *topBarTrailing = [NSLayoutConstraint constraintWithItem:[self topBar]
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1
																		   constant:0];
		// Bottom of topBar is attached to top of datePicker with no extra space
		NSLayoutConstraint *topBarToPicker = [NSLayoutConstraint constraintWithItem:[self topBar]
																		  attribute:NSLayoutAttributeBottom
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self picker]
																		  attribute:NSLayoutAttributeTop
																		 multiplier:1
																		   constant:0];
		// topBar's height
		NSLayoutConstraint *topBarHeight = [NSLayoutConstraint constraintWithItem:[self topBar]
																		attribute:NSLayoutAttributeHeight
																		relatedBy:NSLayoutRelationEqual
																		   toItem:nil
																		attribute:NSLayoutAttributeNotAnAttribute
																	   multiplier:1
																		 constant:HEIGHT_PICKER_TOPBAR];
		
		////////////////////////////////////////////
		/////// Constraints for label
		// Vertically and horizontally centered within the bar
		NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:[self label]
																		attribute:NSLayoutAttributeCenterX
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self topBar]
																		attribute:NSLayoutAttributeCenterX
																	   multiplier:1
																		 constant:0];
		NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:[self label]
																		attribute:NSLayoutAttributeCenterY
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self topBar]
																		attribute:NSLayoutAttributeCenterY
																	   multiplier:1
																		 constant:0];
		
		///////////////////////////////////////////
		////// Constraints for dismiss button:
		// Button's right side is aligned to right side of topBar with a margin (unfortunately,
		// NSLayoutAttributeTrailingMargin was only introduced in iOS 8)
		NSLayoutConstraint *buttonTrailing = [NSLayoutConstraint constraintWithItem:[self topBar]
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self dismissButton]
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1
																		   constant:MARGIN_PICKER_DISMISSBTN_RIGHT];
		// Button is center-aligned vertically within the top bar
		NSLayoutConstraint *buttonCenterY = [NSLayoutConstraint constraintWithItem:[self dismissButton]
																		 attribute:NSLayoutAttributeCenterY
																		 relatedBy:NSLayoutRelationEqual
																			toItem:[self topBar]
																		 attribute:NSLayoutAttributeCenterY
																		multiplier:1
																		  constant:0];
		
		// Add all constraints to the view ('self')
		[self addConstraints:transparencyViewHorizontal];
		[self addConstraints:transparencyViewVertical];
		[self addConstraints:@[pickerLeading, pickerTrailing, pickerBottom,
							   topBarLeading, topBarTrailing, topBarToPicker, topBarHeight,
							   buttonTrailing, buttonCenterY,
							   labelCenterX, labelCenterY]];
	}
	return self;
}

#pragma mark - Presenting and dismissing
// Fade in and slide in
- (void)show
{
	// The view controller that is calling this method is responsible for calling -addSubview:
	// to add this object to its view hierarchy
	
	// Don't do anything if we are already visible/shown
	if([self visible])
		return;
	
	// Slide in the picker (bottom of picker aligned with bottom of view)
	[[self pickerShowHideConstraint] setConstant:0];
	
	// Animate the alpha transition and slide-in
	[UIView animateWithDuration:ANIM_DURATION_PICKER
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self layoutIfNeeded]; // causes the new constraint constant to be applied
						 [[self transparencyView] setAlpha:1.0];
					 }
					 completion:^(BOOL finished){
						 if(finished)
							 [self setVisible:YES];
					 }];
}

// Fade out and slide out, and remove ourselves from our superview
- (void)dismiss
{
	// Don't do anything if we not visible
	if(![self visible])
		return;
	
	// Tell the delegate that the dismiss button was pressed and give it a reference to this instance
	if([self delegate] != nil)
		[[self delegate] datePickerWillDismiss:self];
	
	// Slide picker and bar down
	[[self pickerShowHideConstraint] setConstant:[[self picker] frame].size.height + HEIGHT_PICKER_TOPBAR];
	
	// Animate the alpha transition and slide-out
	[UIView animateWithDuration:ANIM_DURATION_PICKER
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [self layoutIfNeeded]; // causes the new constraint constant to be applied
						 [[self transparencyView] setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
						 [self setVisible:NO];
						 [self removeFromSuperview];
					 }];
}

//#pragma mark - UIDatePicker methods
//// Returns the UIDatePicker's date
//- (NSDate *)date
//{
//	return [[self datePicker] date];
//}
//
//// Sets the date that te UIDatePicker is displaying
//- (void)setDate:(NSDate *)date
//{
//	if([self datePicker] != nil)
//		[[self datePicker] setDate:date animated:NO];
//}

#pragma mark - Delegate-calling methods
- (void)valueChanged
{
	// Tell the delegate that the value of the date picker has changed and give it a reference
	// to this instance
	if([self delegate] != nil)
		[[self delegate] datePickerValueChanged:self];
}

@end
