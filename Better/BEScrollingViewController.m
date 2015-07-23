//
//  BetterViewController.m
//  Better
//
//  Created by Peter on 5/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEScrollingViewController.h"

@interface BEScrollingViewController ()

@end

@implementation BEScrollingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Register to get notifications for when the keyboard shows and hides
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	CGRect mainViewR = [[self view] frame];
//	CGRect scrollViewR = [[self scrollView] frame];
//	CGRect scrollContentR = [[self scrollContentView] frame];
	
//	CGRect newScrollRect = [[self scrollView] frame];
//	newScrollRect.origin.y = 0;
//	[[self scrollView] setFrame:newScrollRect];
	
	[[self view] layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Keyboard notifications
// Called when keyboard is about to appear
- (void)keyboardWillShow:(NSNotification *)notification
{
	// The frame of the keyboard when it is on the screen
	CGRect kFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	// The duration of the keyboard-slide animation
	NSTimeInterval animDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	// Set the bottom of the scroll view to be at the top of the keyboard
	CGFloat keyboardHeight = kFrame.size.height;
//	[[self bottomConstraintContent] setConstant:keyboardHeight];
	
	// Animate the change so it follows the keyboard
	[[self view] layoutIfNeeded];
	[UIView animateWithDuration:animDuration animations:^{
		[[self bottomConstraint] setConstant:keyboardHeight];
		[[self view] layoutIfNeeded];
	}];
}

// Called when keyboard is about to disappear
- (void)keyboardWillHide:(NSNotification *)notification
{
	// Restore the scroll view's bottom to match the bottom of the outer UIView
	NSTimeInterval animDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//	[[self bottomConstraintContent] setConstant:0];
	
	// Animate the change
	[[self view] layoutIfNeeded];
	[UIView animateWithDuration:animDuration animations:^{
		[[self bottomConstraint] setConstant:0];
		[[self view] layoutIfNeeded];
	}];
}

#pragma mark - Dealloc
- (void)dealloc
{
    // Remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
