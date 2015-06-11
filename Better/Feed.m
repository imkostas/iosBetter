#import "Feed.h"

@interface Feed ()
{
	// Variable to save the original (non-full-width) width of the filter drawer
	float filterWidthOriginal;
}

// Methods for hiding and showing the drawers, and detecting if they are hidden or not hidden
- (void)hideMenuDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (void)showMenuDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (BOOL)menuDrawerIsHidden;

- (void)hideFilterDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (void)showFilterDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (BOOL)filterDrawerIsHidden;

// Method for responding to taps on the transparent overlay
- (void)tappedOnOverlayView:(UITapGestureRecognizer *)gesture;

@end

@implementation Feed

#pragma mark - ViewController management
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Set up the navigation bar for Feed areas
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	[self setTitle:@"Everything"];
	
	// Set view properties
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up gesture recognizers for screen edges
	_leftEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFromLeftEdge:)];
	_rightEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFromRightEdge:)];
	[[self leftEdgePanRecognizer] setEdges:UIRectEdgeLeft];
	[[self rightEdgePanRecognizer] setEdges:UIRectEdgeRight];
	[[self view] setGestureRecognizers:@[[self leftEdgePanRecognizer], [self rightEdgePanRecognizer]]];
	
	// Set up gesture recognizers for dragging drawers when they are already out
	UIPanGestureRecognizer *panMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnMenuDrawer:)];
	UIPanGestureRecognizer *panFilter = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnFilterDrawer:)];
	[[self menuDrawer] addGestureRecognizer:panMenu];
	[[self filterDrawer] addGestureRecognizer:panFilter];
	
	// Save references to recognizers so they can be disabled when it's necessary
	[self setPanMenuDrawerGesture:panMenu];
	[self setPanFilterDrawerGesture:panFilter];
	
	// Set up tap recognizer for overlay view
	UITapGestureRecognizer *tapOnOverlayGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnOverlayView:)];
	[[self transparencyView] addGestureRecognizer:tapOnOverlayGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Store the initial value of the filter drawer
	filterWidthOriginal = [[self filterWidthConstraint] constant];
	
	// Move the drawers off of the screen
	[self hideMenuDrawerAnimated:NO includingOverlay:NO];
	[self hideFilterDrawerAnimated:NO includingOverlay:NO];
}

#pragma mark - Navigation, embed segues
// Called for navigation and embed segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// "Catch" the menu and filter view controllers as they are being loaded
	if([[segue identifier] isEqualToString:STORYBOARD_ID_SEGUE_EMBED_MENU])
	{
		
	}
	else if([[segue identifier] isEqualToString:STORYBOARD_ID_SEGUE_EMBED_FILTER])
	{
		// Set the Filter delegate as this object
		FilterViewController *filterVC = (FilterViewController *)[segue destinationViewController];
		[filterVC setDelegate:self];
	}
}

#pragma mark - Responding to bar button item presses
- (IBAction)menuButtonPressed:(id)sender
{
	// Hide the Filter drawer (if it's open)
	[self hideFilterDrawerAnimated:YES includingOverlay:NO];
	
	// Toggle the Menu drawer
	if([self menuDrawerIsHidden])	// If Menu is not visible
		[self showMenuDrawerAnimated:YES includingOverlay:YES];
	else							// If Menu is visible
		[self hideMenuDrawerAnimated:YES includingOverlay:YES];
}

- (IBAction)filterButtonPressed:(id)sender
{
	// Hide the Menu drawer (if it's open)
	[self hideMenuDrawerAnimated:YES includingOverlay:NO];
	
	// Toggle the Filter drawer
	if([self filterDrawerIsHidden])	// If Filter is not visible
		[self showFilterDrawerAnimated:YES includingOverlay:YES];
	else							// If Filter is visible
		[self hideFilterDrawerAnimated:YES includingOverlay:YES];
}

#pragma mark - Filter delegate methods
// Called by FilterViewcontroller when the filter is changed
- (void)filterChanged:(NSString *)filterString
{
	// Hide the drawer, overlay
	[self hideFilterDrawerAnimated:YES includingOverlay:YES];
//	[self hideTransparentOverlay];
	
	// Change the title of this view controller with a cross dissolve animation
//	[UIView transitionWithView:[[self navigationController] navigationBar]
//					  duration:ANIM_DURATION_CHANGE_VIEWCONTROLLER_TITLE
//					   options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve
//					animations:^{
//						[self setTitle:filterString];
//					}
//					completion:nil];
	// ^^ Looks awful on iOS 7, for some reason the whole bar goes white while it's transitioning;
	// this doesn't happen on iOS 8 (maybe a simulator problem?)
	
	// Change title
	[self setTitle:filterString];
}

// Called when the UISearchBar in the filter drawer has focus
- (void)filterSearchDidBegin:(UISearchBar *)searchBar
{
	// Grow the drawer to take up the whole width of the screen
	[[self filterWidthConstraint] setConstant:[[self view] frame].size.width];
	
	// Make the bar buttons disappear
	[[self navigationItem] setLeftBarButtonItem:nil animated:YES];
	[[self navigationItem] setRightBarButtonItem:nil animated:YES];
	
	// Disable the filter drawer's pan gesture
	[[self panFilterDrawerGesture] setEnabled:NO];
	
	// Animate the growing
	[UIView animateWithDuration:ANIM_DURATION_CHANGE_DRAWER_SIZE
					 animations:^{
						 [[self view] layoutIfNeeded];
					 }];
}

// Called when the UISearchBar in the filter drawer loses focus
- (void)filterSearchDidEnd:(UISearchBar *)searchBar
{
	// Shrink the drawer to its original size again
	[[self filterWidthConstraint] setConstant:filterWidthOriginal];
	
	// Make the bar buttons reappear
	[[self navigationItem] setLeftBarButtonItem:[self menuBarButtonItem] animated:YES];
	[[self navigationItem] setRightBarButtonItem:[self filterBarButtonItem] animated:YES];
	
	// Enable the filter drawer's pan gesture
	[[self panFilterDrawerGesture] setEnabled:YES];
	
	// Animate the shrinking
	[UIView animateWithDuration:ANIM_DURATION_CHANGE_DRAWER_SIZE
					 animations:^{
						 [[self view] layoutIfNeeded];
						 
					 }];
}

#pragma mark - Toggling state of drawers without gestures
// Hide the menu drawer (no gesture)
- (void)hideMenuDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay
{
	// Hide the drawer (set its left side as -(drawer width) to the left of the screen)
	[[self menuLeadingConstraint] setConstant: -1 * [[self menuWidthConstraint] constant]];
	
	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
							 if(animateOverlay)
								 [[self transparencyView] setAlpha:0];
						 }
						 completion:^(BOOL completed){
							 // The purpose of animateOverlay is to not touch the transparent overlay in certain
							 // cases (i.e. when one drawer is open, and you press the navigation bar button
							 // to open the other drawer; you don't want to hide the overlay at all
							 if(animateOverlay)
								[[self transparencyView] setHidden:YES]; // Hide overlay (lets taps through it)
						 }];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self transparencyView] setAlpha:0];
	}
}
// Show the menu drawer (no gesture)
- (void)showMenuDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay
{
	// Show the drawer (set its left side to be aligned with the left of the screen)
	[[self menuLeadingConstraint] setConstant:0];
	
	// Show the black overlay (still at 0 alpha)
	if(animateOverlay)
		[[self transparencyView] setHidden:NO];

	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
							 if(animateOverlay)
								 [[self transparencyView] setAlpha:ALPHA_FEED_OVERLAY];
						 }
						 completion:nil];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self transparencyView] setAlpha:ALPHA_FEED_OVERLAY];
	}
}
- (BOOL)menuDrawerIsHidden {  return ([[self menuLeadingConstraint] constant] == 0) ? NO : YES;  }

// Hide filter (no gesture)
- (void)hideFilterDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay
{
	// Hide the drawer (set its right side as (drawer width) right of the right side of the screen)
	[[self filterTrailingConstraint] setConstant: -1 * [[self filterWidthConstraint] constant]];
	
	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
							 if(animateOverlay)
								 [[self transparencyView] setAlpha:0];
						 }
						 completion:^(BOOL completed){
							 if(animateOverlay)
								[[self transparencyView] setHidden:YES]; // Hide overlay
						 }];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self transparencyView] setAlpha:0];
	}
}
// Show filter (no gesture)
- (void)showFilterDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay
{
	// Show the drawer (set its right side to be aligned with the right of the screen)
	[[self filterTrailingConstraint] setConstant:0];
	
	// Show the black overlay (still at 0 alpha)
	if(animateOverlay)
		[[self transparencyView] setHidden:NO];
	
	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
							 if(animateOverlay)
								 [[self transparencyView] setAlpha:ALPHA_FEED_OVERLAY];
						 }
						 completion:nil];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self transparencyView] setAlpha:ALPHA_FEED_OVERLAY];
	}
}
- (BOOL)filterDrawerIsHidden {  return ([[self filterTrailingConstraint] constant] == 0) ? NO : YES;  }

#pragma mark - Gesture recognizers
// Swiping from left edge
- (void)swipeFromLeftEdge:(UIScreenEdgePanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	// Perform different actions based on the state of the gesture:
	
	// Gesture just started
	if([gesture state] == UIGestureRecognizerStateBegan)
	{
		// Hide the filter drawer
		[self hideFilterDrawerAnimated:YES includingOverlay:NO];
		
		// Show transparent overlay
//		if(![self filterDrawerIsHidden])
			[[self transparencyView] setHidden:NO];
	}
	//
	// User is in the process of moving their finger around
	else if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x <= [[self menuWidthConstraint] constant]) // Limits maximum dragging width
		{
			[[self menuLeadingConstraint] setConstant:(-1 * [[self menuWidthConstraint] constant] + touchPoint.x)];
			[[self transparencyView] setAlpha:(touchPoint.x / [[self menuWidthConstraint] constant] * ALPHA_FEED_OVERLAY)];
		}
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled)
	{
		// If the velocity of the gesture is fast, we want to move out the drawer all the way, even if the user
		// released the drawer close to the left of the screen
		
		if(touchPoint.x > [[self menuWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
			// Drawer is more than (width/ratio) of the way out
			[self showMenuDrawerAnimated:YES includingOverlay:YES];
		else
		{
			// Drawer is less than (width/ratio) of the way out
			
			if(touchVelocity.x < GESTURE_THRESHOLD_FAST_DRAWER) // Gesture is slow
				[self hideMenuDrawerAnimated:YES includingOverlay:YES]; // Hide drawer
			else // Gesture is fast
				[self showMenuDrawerAnimated:YES includingOverlay:YES]; // Show drawer
		}
	}
}

// Swiping from right edge
- (void)swipeFromRightEdge:(UIScreenEdgePanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	// Perform different actions based on the state of the gesture:
	
	// Gesture just started
	if([gesture state] == UIGestureRecognizerStateBegan)
	{
		// Hide the filter drawer
		[self hideMenuDrawerAnimated:YES includingOverlay:NO];
		
		// Show transparent overlay
//		if(![self menuDrawerIsHidden])
			[[self transparencyView] setHidden:NO];
	}
	//
	// User is in the process of moving their finger around
	else if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x >= -1 * [[self filterWidthConstraint] constant]) // Limits maximum dragging width
		{
			[[self filterTrailingConstraint] setConstant:(-1 * [[self filterWidthConstraint] constant] - touchPoint.x)];
			[[self transparencyView] setAlpha:(abs((int)touchPoint.x) / [[self filterWidthConstraint] constant] * ALPHA_FEED_OVERLAY)];
		}
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled)
	{
		// If the velocity of the gesture is fast, we want to move out the drawer all the way, even if the user
		// released the drawer close to the left of the screen
		
		if(touchPoint.x < (-1 * [[self filterWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH))
			// Drawer is more than (width/ratio) of the way out
			[self showFilterDrawerAnimated:YES includingOverlay:YES];
		else
		{
			// Drawer is less than (width/ratio) of the way out
			
			if(touchVelocity.x > (-1 * GESTURE_THRESHOLD_FAST_DRAWER)) // Gesture is slow
				[self hideFilterDrawerAnimated:YES includingOverlay:YES]; // Hide drawer
			else // Gesture is fast
				[self showFilterDrawerAnimated:YES includingOverlay:YES]; // Show drawer
		}
	}
}

// For panning on the menu drawer
- (void)swipeOnMenuDrawer:(UIPanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	//
	// User is in the process of moving their finger around
	if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x <= 0) // Limits maximum dragging width (touchPoint starts at 0 at the start of the pan)
		{
			[[self menuLeadingConstraint] setConstant:touchPoint.x];
			[[self transparencyView] setAlpha: ALPHA_FEED_OVERLAY - (abs((int)touchPoint.x) / [[self menuWidthConstraint] constant] * ALPHA_FEED_OVERLAY)];
		}
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled)
	{
		// If the velocity of the gesture is fast, we want to move out the drawer all the way, even if the user
		// released the drawer close to the left of the screen
		
		if(abs((int)touchPoint.x) > [[self menuWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
			// Drawer is more than (width/ratio) of the way in
			[self hideMenuDrawerAnimated:YES includingOverlay:YES];
		else
		{
			// Drawer is less than (width/ratio) of the way in
			
			if(abs((int)touchVelocity.x) < GESTURE_THRESHOLD_FAST_DRAWER) // Gesture is slow
				[self showMenuDrawerAnimated:YES includingOverlay:YES]; // show drawer
			else // Gesture is fast
				[self hideMenuDrawerAnimated:YES includingOverlay:YES]; // hide drawer
		}
	}
}

// For panning on the filter drawer
- (void)swipeOnFilterDrawer:(UIPanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	//
	// User is in the process of moving their finger around
	if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x > 0) // Limits maximum dragging width (touchPoint starts at 0 at the start of the pan)
		{
			[[self filterTrailingConstraint] setConstant: -1 * touchPoint.x];
			[[self transparencyView] setAlpha: ALPHA_FEED_OVERLAY - (abs((int)touchPoint.x) / [[self filterWidthConstraint] constant] * ALPHA_FEED_OVERLAY)];
		}
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled)
	{
		// If the velocity of the gesture is fast, we want to move in the drawer all the way, even if the user
		// released the drawer close to where it started
		
		if(abs((int)touchPoint.x) > [[self filterWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
			// Drawer is more than (width/ratio) of the way in
			[self hideFilterDrawerAnimated:YES includingOverlay:YES];
		else
		{
			// Drawer is less than (width/ratio) of the way in
			
			if(abs((int)touchVelocity.x) < GESTURE_THRESHOLD_FAST_DRAWER) // Gesture is slow
				[self showFilterDrawerAnimated:YES includingOverlay:YES]; // show drawer
			else // Gesture is fast
				[self hideFilterDrawerAnimated:YES includingOverlay:YES]; // hide drawer
		}
	}
}

// Tapping on transparent overlay
- (void)tappedOnOverlayView:(UITapGestureRecognizer *)gesture
{
	if(![self menuDrawerIsHidden])
		[self hideMenuDrawerAnimated:YES includingOverlay:YES]; // If not hidden, hide it
	if(![self filterDrawerIsHidden])
		[self hideFilterDrawerAnimated:YES includingOverlay:YES]; // If not hidden, hide it
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
