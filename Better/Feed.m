#import "Feed.h"

@interface Feed ()
{
	// Variables to keep the drawers from sliding too far onto the screen
	float menuSlideWidthMaximum;
	float filterSlideWidthMaximum;
}

// Quick methods for hiding and showing the drawers, and detecting if they are hidden or not hidden
- (void)hideMenuDrawer;
- (void)showMenuDrawer;
- (BOOL)menuDrawerIsHidden;

- (void)hideFilterDrawer;
- (void)showFilterDrawer;
- (BOOL)filterDrawerIsHidden;

@end

@implementation Feed

#pragma mark - ViewController management
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Set up the navigation bar
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
}

- (void)viewWillAppear:(BOOL)animated
{
	// Store the initial values of
	// Move the drawers off of the screen
	[self hideMenuDrawer];
	[self hideFilterDrawer];
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
	// Toggle the Menu drawer
	
	if([self menuDrawerIsHidden])	// If Menu is not visible
		[self showMenuDrawer];
	else							// If Menu is visible
		[self hideMenuDrawer];
	
	// Hide the Menu drawer (if it's open)
	[self hideFilterDrawer];
	
	// Animate the change in position
	[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [[self view] layoutIfNeeded];
					 }
					 completion:nil];
}

- (IBAction)filterButtonPressed:(id)sender
{
	// Toggle the Filter drawer
	
	if([self filterDrawerIsHidden])	// If Filter is not visible
		[self showFilterDrawer];
	else							// If Filter is visible
		[self hideFilterDrawer];
	
	// Hide the Menu drawer (if it's open)
	[self hideMenuDrawer];
	
	// Animate the change in position
	[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 [[self view] layoutIfNeeded];
					 }
					 completion:nil];
}

#pragma mark - Filter delegate methods
// Called by FilterViewcontroller when the filter is changed
- (void)filterChanged:(NSString *)filterString
{
	// Change the title of this view controller with a cross dissolve animation
	[UIView transitionWithView:[[self navigationController] navigationBar]
					  duration:ANIM_DURATION_CHANGE_VIEWCONTROLLER_TITLE
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^{
						[self setTitle:filterString];
					}
					completion:nil];
}

#pragma mark - Toggling state of drawers (show/hide)
- (void)hideMenuDrawer {  [[self menuLeadingConstraint] setConstant: -1 * [[self menuWidthConstraint] constant]];  }
- (void)showMenuDrawer {  [[self menuLeadingConstraint] setConstant:0];  }
- (BOOL)menuDrawerIsHidden {  return ([[self menuLeadingConstraint] constant] == 0) ? NO : YES;  }

- (void)hideFilterDrawer {  [[self filterTrailingConstraint] setConstant: -1 * [[self filterWidthConstraint] constant]];  }
- (void)showFilterDrawer {  [[self filterTrailingConstraint] setConstant:0]; }
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
		// Determine the maximum sliding distance the drawer can slide
		menuSlideWidthMaximum = [[self menuWidthConstraint] constant];
		
		// Hide the filter drawer
		[self hideFilterDrawer];
		
		// Animate the hide
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:nil];
	}
	//
	// User is in the process of moving their finger around
	else if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x <= menuSlideWidthMaximum) // Limits maximum dragging width
			[[self menuLeadingConstraint] setConstant:(-1 * menuSlideWidthMaximum + touchPoint.x)];
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded)
	{
		// If the velocity of the gesture is fast, we want to move out the drawer all the way, even if the user
		// released the drawer close to the left of the screen
		
		if(touchPoint.x > menuSlideWidthMaximum / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
			// Drawer is more than (width/ratio) of the way out
			[[self menuLeadingConstraint] setConstant:0]; // Move out all the way
		else
		{
			// Drawer is less than (width/ratio) of the way out
			
			if(touchVelocity.x < GESTURE_THRESHOLD_FAST_DRAWER) // Gesture is slow
				[[self menuLeadingConstraint] setConstant:(-1 * menuSlideWidthMaximum)]; // Hide drawer
			else // Gesture is fast
				[[self menuLeadingConstraint] setConstant:0]; // Move out all the way
		}
		
		// Animate the change in position
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:nil];
	}
	else if([gesture state] == UIGestureRecognizerStateCancelled)
	{
		NSLog(@"gesture cancelled");
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
		// Determine the maximum sliding distance the drawer can slide
		filterSlideWidthMaximum = [[self filterWidthConstraint] constant];
		
		// Hide the Menu drawer
		[self hideMenuDrawer];
		
		// Animate the hide
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:nil];
	}
	//
	// User is in the process of moving their finger around
	else if([gesture state] == UIGestureRecognizerStateChanged)
	{
		// Move the drawer according to the x-position of the gesture
		if(touchPoint.x <= filterSlideWidthMaximum) // Limits maximum dragging width
			[[self filterTrailingConstraint] setConstant:(-1 * filterSlideWidthMaximum - touchPoint.x)];
	}
	//
	// Upon user releasing their finger, move the drawer to where it should go
	else if([gesture state] == UIGestureRecognizerStateEnded)
	{
		// If the velocity of the gesture is fast, we want to move out the drawer all the way, even if the user
		// released the drawer close to the left of the screen
		
		if(touchPoint.x < (-1 * filterSlideWidthMaximum / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH))
			// Drawer is more than (width/ratio) of the way out (this "less-than" is opposite to the left
			// edge gesture)
			[[self filterTrailingConstraint] setConstant:0]; // Move out all the way
		else
		{
			// Drawer is less than (width/ratio) of the way out
			
			if(touchVelocity.x > (-1 * GESTURE_THRESHOLD_FAST_DRAWER)) // Gesture is slow
				[[self filterTrailingConstraint] setConstant:(-1 * filterSlideWidthMaximum)]; // Hide drawer
			else // Gesture is fast
				[[self filterTrailingConstraint] setConstant:0]; // Move out all the way
		}
		
		// Animate the change in position
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:nil];
	}
	else if([gesture state] == UIGestureRecognizerStateCancelled)
	{
		NSLog(@"gesture cancelled");
	}
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
