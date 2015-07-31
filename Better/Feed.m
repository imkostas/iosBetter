#import "Feed.h"

@interface Feed ()
{
	// Variable to save the original (non-full-width) width of the filter drawer
	float filterWidthOriginal;
}

// Gesture recognizers
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer	*leftEdgePanRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer	*rightEdgePanRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer			*panCenterViewRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer			*tapCenterViewRecognizer;

// Hide both drawers (i.e. move the centerView to the center)
- (void)moveCenterViewToCenterAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn;

// Methods for hiding and showing the drawers, and detecting if they are hidden or not hidden
//- (void)hideMenuDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (void)showMenuDrawerAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn;
- (BOOL)menuDrawerIsHidden;

//- (void)hideFilterDrawerAnimated:(BOOL)animated includingOverlay:(BOOL)animateOverlay;
- (void)showFilterDrawerAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn;
- (BOOL)filterDrawerIsHidden;

// Method for panning the centerView (used for dragging it back to the center)
- (void)panCenterView:(UIPanGestureRecognizer *)gesture;

// Method for responding to taps on the center view
- (void)tappedOnCenterView:(UITapGestureRecognizer *)gesture;

// A reference to a FeedTableViewController object, which is embedded as a child view controller inside this object
// and displays the actual list of posts
@property (weak, nonatomic) FeedTableViewController *feedTableViewController;

// A reference to a storyboard-instantiated UINavigationController, to which we pass the image that the
// UIImagePickerController returns (this image picker is different from the one within PostLayoutViewController)
//@property (strong, nonatomic) UINavigationController *postNavigationController;

@end

@implementation Feed

#pragma mark - ViewController management
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Set up the navigation bar for Feed areas
	[[self navigationBarCustom] setBarTintColor:COLOR_BETTER_DARK];
	[[self navigationBarCustom] setTintColor:[UIColor whiteColor]];
	[[self navigationBarCustom] setTranslucent:NO];
	
	// Set title
	[[self navigationItemCustom] setTitle:@"Everything"];
	
	// Set view properties
	[[self centerView] setBackgroundColor:COLOR_GRAY_FEED];
	
	// Set up gesture recognizers for screen edges
	_leftEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFromLeftEdge:)];
	_rightEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeFromRightEdge:)];
	[[self leftEdgePanRecognizer] setEdges:UIRectEdgeLeft];
	[[self rightEdgePanRecognizer] setEdges:UIRectEdgeRight];
	[[self leftEdgePanRecognizer] setMaximumNumberOfTouches:1];
	[[self rightEdgePanRecognizer] setMaximumNumberOfTouches:1];
	[[self centerView] setGestureRecognizers:@[[self leftEdgePanRecognizer], [self rightEdgePanRecognizer]]];
	
	// Set up a gesture recognizer for dragging the centerView back to the middle
	_panCenterViewRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCenterView:)];
	[_panCenterViewRecognizer setMaximumNumberOfTouches:1];
	[_panCenterViewRecognizer setEnabled:NO]; // Disable for now (enable it when showing either drawer)
	[[self centerView] addGestureRecognizer:_panCenterViewRecognizer];
	
	// Set up tap recognizer for centerView (this is disabled when centerView is not slid off to either side)
	_tapCenterViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnCenterView:)];
	[_tapCenterViewRecognizer setEnabled:NO]; // Disable for now (enable it when showing either drawer)
	[[self centerView] addGestureRecognizer:_tapCenterViewRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	// Store the initial value of the filter drawer
	filterWidthOriginal = [[self filterWidthConstraint] constant];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    // Set modal transition style back to Cover Vertical (possibly set by Intro object)
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
}

// Called after the view has laid out its subviews (thus.. we can figure out the real bounds of centerView
// in order to draw its shadow)
- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	// Draw shadow on sides of centerView
	CALayer *layer = [[self centerView] layer];
	CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:[[self centerView] bounds]] CGPath];
	[layer setMasksToBounds:NO];
	[layer setShadowPath:shadowPath];
	[layer setShadowOpacity:0.5];
	[layer setShadowOffset:CGSizeMake(0,1)];
	[layer setShadowRadius:5];
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
    else if([[segue identifier] isEqualToString:STORYBOARD_ID_SEGUE_EMBED_FEED_MAIN]) // Container for the Feed
    {
        // Save the reference to the embedded FeedTableViewController
        _feedTableViewController = (FeedTableViewController *)[segue destinationViewController];
    }
}

#pragma mark - Responding to bar button item presses
- (IBAction)menuButtonPressed:(id)sender
{
	// Hide the Filter drawer (if it's open)
//	[self hideFilterDrawerAnimated:YES includingOverlay:NO];
	
	// Toggle the Menu drawer
	if([self menuDrawerIsHidden])	// If Menu is not visible
		[self showMenuDrawerAnimated:YES easeIn:YES];
	else							// If Menu is visible
		[self moveCenterViewToCenterAnimated:YES easeIn:YES];
}

- (IBAction)filterButtonPressed:(id)sender
{
	// Hide the Menu drawer (if it's open)
//	[self hideMenuDrawerAnimated:YES includingOverlay:NO];
	
	// Toggle the Filter drawer
	if([self filterDrawerIsHidden])	// If Filter is not visible
		[self showFilterDrawerAnimated:YES easeIn:YES];
	else							// If Filter is visible
		[self moveCenterViewToCenterAnimated:YES easeIn:YES];
}

#pragma mark - Filter delegate methods
// Called by FilterViewcontroller when the filter is changed
- (void)filterChanged:(NSString *)filterString
{
    // Update the Feed's posts with the new filter
    if([filterString isEqualToString:@"Everything"])
        [[[self feedTableViewController] dataController] setFilterString:FEED_FILTER_EVERYTHING];
    
    else if([filterString isEqualToString:@"Favorite Tags"])
        [[[self feedTableViewController] dataController] setFilterString:FEED_FILTER_FAVORITETAGS];
    
    else if([filterString isEqualToString:@"Following"])
        [[[self feedTableViewController] dataController] setFilterString:FEED_FILTER_FOLLOWING];
    
    else if([filterString isEqualToString:@"Trending"])
        [[[self feedTableViewController] dataController] setFilterString:FEED_FILTER_TRENDING];
    
	// Hide the drawer, overlay
	[self moveCenterViewToCenterAnimated:YES easeIn:YES];
	
	// *** This doesn't really apply anymore:
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
	[[self navigationItemCustom] setTitle:filterString];
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
//	[[self panFilterDrawerGesture] setEnabled:NO];
	
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
//	[[self panFilterDrawerGesture] setEnabled:YES];
	
	// Animate the shrinking
	[UIView animateWithDuration:ANIM_DURATION_CHANGE_DRAWER_SIZE
					 animations:^{
						 [[self view] layoutIfNeeded];
					 }];
}

#pragma mark - UINavigationBarDelegate positioning
// Where to position a UINavigationBar
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
	// Extends the navigation bar's color all the way to the top of its enclosing view, including the status bar
	return UIBarPositionTopAttached;
}

#pragma mark - Creating a post, UIImagePickerController delegate
- (IBAction)pressedCreatePost:(id)sender
{
    // Loads the Create Post navigation controller
    UIStoryboard *createPostStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_FILENAME_CREATEPOST bundle:[NSBundle mainBundle]];
    UINavigationController *postNavigation = [createPostStoryboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CREATEPOST_NAVIGATION];
    
    // Present the nav controller
    [self presentViewController:postNavigation animated:YES completion:nil];

//    // Create a one-off instance of a UIImagePickerController just for selecting the first image for a post,
//    // because we want it to show up first (and not the post creation view controller)
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    
//    // Make this class the delegate of the ImagePickerController to get the image it captures/
//    // retrieves
//    [imagePicker setDelegate:self];
//    
//    // If camera is available, use it; otherwise, open up the saved photos list
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        [imagePicker setShowsCameraControls:YES];
//    }
//    else // No camera
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//    
//    // More properties
//    [imagePicker setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [imagePicker setAllowsEditing:YES];
//    
//    // Present the image picker
//    [self presentViewController:imagePicker animated:YES completion:^(void){
//        // Loads the Create Post navigation controller
//        UIStoryboard *createPostStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_FILENAME_CREATEPOST bundle:[NSBundle mainBundle]];
//        UINavigationController *postNavigation = [createPostStoryboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_CREATEPOST_NAVIGATION];
//        
//        // Set transition property
//        [postNavigation setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        
//        // Save reference so we can run -presentViewController later, if the user selects an image
//        [self setPostNavigationController:postNavigation];
//    }];
}

// Called when the image picker successfully gets an image
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    // Get the image from the picker
//    UIImage *firstPostImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    
//    // Dismiss the image picker
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"Image picker finished picking image");
//    }];
//    
//    // Show the post creation view controller
//    [self presentViewController:[self postNavigationController] animated:YES completion:nil];
//}
//
//// Called when the image picker is cancelled
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    // Dismiss the image picker
//    [self dismissViewControllerAnimated:YES completion:^(void){
//        NSLog(@"Image picker cancelled");
//    }];
//}

#pragma mark - Toggling state of drawers without gestures
// Hide both drawers (i.e. move the centerView to the center)
- (void)moveCenterViewToCenterAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn
{
	[[self centerViewLeadingConstraint] setConstant:0]; // No offset from left
	
	// Animate change
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:(shouldEaseIn) ? UIViewAnimationOptionCurveEaseInOut : UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:^(BOOL completed) {
							 if(completed) {
								 // Re-enable both screen edge pan gestures
								 [[self leftEdgePanRecognizer] setEnabled:YES];
								 [[self rightEdgePanRecognizer] setEnabled:YES];
								 
								 // Disable panning on centerView
								 [[self panCenterViewRecognizer] setEnabled:NO];
								 
								 // Enable interaction with feed container
								 [[self feedContainer] setUserInteractionEnabled:YES];
								 
								 // Set both drawers as not hidden
								 [[self menuDrawer] setHidden:NO];
								 [[self filterDrawer] setHidden:NO];
							 }
						 }];
	}
	else // No animation
	{
		[[self view] layoutIfNeeded];
		
		// Re-enable both screen edge pan gestures
		[[self leftEdgePanRecognizer] setEnabled:YES];
		[[self rightEdgePanRecognizer] setEnabled:YES];
		
		// Disable panning on centerView
		[[self panCenterViewRecognizer] setEnabled:NO];
		
		// Enable interaction with feed container
		[[self feedContainer] setUserInteractionEnabled:YES];
		
		// Set both drawers as not hidden
		[[self menuDrawer] setHidden:NO];
		[[self filterDrawer] setHidden:NO];
	}
}

// Show the menu drawer (no gesture)
- (void)showMenuDrawerAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn
{
	// Hide the filter view
	[[self filterDrawer] setHidden:YES];
	
	// Disable the screen edge pan gestures
	[[self leftEdgePanRecognizer] setEnabled:NO];
	[[self rightEdgePanRecognizer] setEnabled:NO];
	
	// Show the drawer (set its left side to be aligned with the left of the screen)
	[[self centerViewLeadingConstraint] setConstant:[[self menuWidthConstraint] constant]];

	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:(shouldEaseIn) ? UIViewAnimationOptionCurveEaseInOut : UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:^(BOOL completed) {
							 if(completed) {
								 [[self tapCenterViewRecognizer] setEnabled:YES]; // Enable tapping on center view
								 [[self panCenterViewRecognizer] setEnabled:YES]; // Enable panning on center view
								 [[self feedContainer] setUserInteractionEnabled:NO]; // Disable interaction with Feed
										// e.g. no scrolling when the Menu or Filter is being shown
							 }
						 }];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self tapCenterViewRecognizer] setEnabled:YES]; // Enable tapping on center view
		[[self panCenterViewRecognizer] setEnabled:YES]; // Enable panning on center view
		[[self feedContainer] setUserInteractionEnabled:NO]; // Disable interaction with Feed
	}
}
- (BOOL)menuDrawerIsHidden {
	return ([[self centerViewLeadingConstraint] constant] > [[self menuWidthConstraint] constant] / 2) ? NO : YES;
}

// Show filter (no gesture)
- (void)showFilterDrawerAnimated:(BOOL)animated easeIn:(BOOL)shouldEaseIn
{
	// Hide the menu view
	[[self menuDrawer] setHidden:YES];
	
	// Disable the screen edge pan gestures
	[[self leftEdgePanRecognizer] setEnabled:NO];
	[[self rightEdgePanRecognizer] setEnabled:NO];
	
	// Show the drawer (set its right side to be aligned with the right of the screen)
	[[self centerViewLeadingConstraint] setConstant:(-1 * [[self filterWidthConstraint] constant])];
	
	// Animate the change in position if animated == TRUE
	if(animated)
	{
		[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
							  delay:0
							options:(shouldEaseIn) ? UIViewAnimationOptionCurveEaseInOut : UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 [[self view] layoutIfNeeded];
						 }
						 completion:^(BOOL completed) {
							 if(completed) {
								 [[self tapCenterViewRecognizer] setEnabled:YES]; // Enable tapping on center view
								 [[self panCenterViewRecognizer] setEnabled:YES]; // Enable panning on center view
								 [[self feedContainer] setUserInteractionEnabled:NO]; // Disable interaction with Feed
							 }
						 }];
	}
	else
	{
		[[self view] layoutIfNeeded]; // No animation
		[[self tapCenterViewRecognizer] setEnabled:YES]; // Enable tapping on center view
		[[self panCenterViewRecognizer] setEnabled:YES]; // Enable panning on center view
		[[self feedContainer] setUserInteractionEnabled:NO]; // Disable interaction with Feed
	}
}
- (BOOL)filterDrawerIsHidden {
	return ([[self centerViewLeadingConstraint] constant] < (-1 * [[self filterWidthConstraint] constant] / 2)) ? NO : YES;
}

#pragma mark - Gesture recognizers
// Swiping from left edge
- (void)swipeFromLeftEdge:(UIScreenEdgePanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	// Perform different actions based on the state of the gesture:
	switch([gesture state])
	{
		case UIGestureRecognizerStateBegan: // Gesture just started
		{
			// Hide the filter view and show the menu view
			[[self menuDrawer] setHidden:NO];
			[[self filterDrawer] setHidden:YES];
			break;
		}
		case UIGestureRecognizerStateChanged: // User is moving finger
		{
			// Move center view according to x-position of gesture, and keep it from moving off the left
			// side of the screen
			if(touchPoint.x >= 0 && touchPoint.x <= [[self menuWidthConstraint] constant])
				[[self centerViewLeadingConstraint] setConstant:touchPoint.x];
			break;
		}
		case UIGestureRecognizerStateEnded: // Gesture ended normally or was interrupted
		case UIGestureRecognizerStateCancelled:
		{
			// Fast gesture
			if(abs((int)touchVelocity.x) > GESTURE_THRESHOLD_FAST_DRAWER)
			{
				if(touchVelocity.x > 0) // Positive velocity, to the right
					[self showMenuDrawerAnimated:YES easeIn:NO];
				else if(touchVelocity.x < 0) // Negative velocity, to the left
					[self moveCenterViewToCenterAnimated:YES easeIn:NO];
			}
			else // Slow gesture
			{
				// If gesture ends when the center view is still mostly shown
				if(touchPoint.x < [[self menuWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
					[self moveCenterViewToCenterAnimated:YES easeIn:NO];
				else
					[self showMenuDrawerAnimated:YES easeIn:NO];
			}
			break;
		}
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStatePossible:
		default:
			break;
	}
}

// Swiping from right edge
- (void)swipeFromRightEdge:(UIScreenEdgePanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	// Perform different actions based on the state of the gesture:
	switch([gesture state])
	{
		case UIGestureRecognizerStateBegan: // Gesture just started
		{
			// Show the filter view and hide the menu view
			[[self menuDrawer] setHidden:YES];
			[[self filterDrawer] setHidden:NO];
			break;
		}
		case UIGestureRecognizerStateChanged: // User is moving finger
		{
			// Move center view according to x-position of gesture, and keep it from moving off the left
			// side of the screen
			if(touchPoint.x <= 0 && touchPoint.x >= -1 * [[self filterWidthConstraint] constant])
				[[self centerViewLeadingConstraint] setConstant:touchPoint.x];
			break;
		}
		case UIGestureRecognizerStateEnded: // Gesture ended normally or was interrupted
		case UIGestureRecognizerStateCancelled:
		{
			// Fast gesture
			if(abs((int)touchVelocity.x) > GESTURE_THRESHOLD_FAST_DRAWER)
			{
				if(touchVelocity.x > 0) // Positive velocity, to the right
					[self moveCenterViewToCenterAnimated:YES easeIn:NO];
				else if(touchVelocity.x < 0) // Negative velocity, to the left
					[self showFilterDrawerAnimated:YES easeIn:NO];
			}
			else // Slow gesture
			{
				// If gesture ends when the center view is still mostly shown
				if(touchPoint.x < -1 * [[self menuWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
					[self showFilterDrawerAnimated:YES easeIn:NO];
				else
					[self moveCenterViewToCenterAnimated:YES easeIn:NO];
			}
			break;
		}
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStatePossible:
		default:
			break;
	}
}

// For tapping on the center view
- (void)tappedOnCenterView:(UITapGestureRecognizer *)gesture
{
	// Return the centerView to the middle
	[self moveCenterViewToCenterAnimated:YES easeIn:YES];
	
	// Disable this gesture (will be enabled by either showMenu... or showFilter...
	[gesture setEnabled:NO];
}

// For panning on the center view
- (void)panCenterView:(UIPanGestureRecognizer *)gesture
{
	// Get the position and velocity of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	CGPoint touchVelocity = [gesture velocityInView:[self view]];
	
	// Perform actions depending on the gesture state
	switch([gesture state])
	{
		case UIGestureRecognizerStateChanged: // User moving finger
		{
			// If the centerView's leading constraint is positive, then the menu drawer is visible.
			// The pan should be limited to only negative values (movement left) and not more left than
			// the left edge of the screen
			if(touchPoint.x < 0 && [[self centerViewLeadingConstraint] constant] > 0)
			{
				CGFloat newLocation = [[self menuWidthConstraint] constant] + touchPoint.x;
				if(newLocation <= 0) newLocation = 1; // Don't go too far left
				
				[[self centerViewLeadingConstraint] setConstant:newLocation];
			}
			// If filter drawer is visible
			else if(touchPoint.x > 0 && [[self centerViewLeadingConstraint] constant] < 0)
			{
				CGFloat newLocation = -1 * [[self filterWidthConstraint] constant] + touchPoint.x;
				if(newLocation >= 0) newLocation = -1; // Don't go too far right
				
				[[self centerViewLeadingConstraint] setConstant:newLocation];
			}
			
			break;
		}
		case UIGestureRecognizerStateEnded: // User lifted finger, or app was closed/switched
		case UIGestureRecognizerStateCancelled:
		{
			// Animate to the proper ending location
			
			// If the velocity is fast, then go in the direction that the gesture is moving in, otherwise,
			// if the gesture velocity is slow, then decide the direction based on how far the gesture has
			// moved in the x-direction
			if(abs((int)touchVelocity.x) > GESTURE_THRESHOLD_FAST_DRAWER)
			{
				// For when the menu is visible
				if([[self centerViewLeadingConstraint] constant] > 0)
				{
					if(touchVelocity.x > 0) // Positive velocity, towards right
						[self showMenuDrawerAnimated:YES easeIn:NO];
					else if(touchVelocity.x < 0) // Negative velocity, towards left
						[self moveCenterViewToCenterAnimated:YES easeIn:NO];
				}
				// For when the filter is visible
				else if([[self centerViewLeadingConstraint] constant] < 0)
				{
					if(touchVelocity.x > 0) // Positive velocity, towards right
						[self moveCenterViewToCenterAnimated:YES easeIn:NO];
					else if(touchVelocity.x < 0) // Negative velocity, towards left
						[self showFilterDrawerAnimated:YES easeIn:NO];
				}
			}
			else // Slow gesture
			{
				// For when the menu is visible
				if([[self centerViewLeadingConstraint] constant] > 0)
				{
					// Gesture ended when centerView was far from the center, so keep the menu visible
					if(touchPoint.x > (-1 * [[self menuWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH))
						[self showMenuDrawerAnimated:YES easeIn:NO];
					else
						// Gesture ended when centerView was close to the center, so move it all the way to the
						// center
						[self moveCenterViewToCenterAnimated:YES easeIn:NO];
				}
				// For when the filter is visible
				else if([[self centerViewLeadingConstraint] constant] < 0)
				{
					// Gesture ended when centerView was far from the center, so keep the filter visible
					if(touchPoint.x < [[self filterWidthConstraint] constant] / RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH)
						[self showFilterDrawerAnimated:YES easeIn:NO];
					else
						// Gesture ended when centerView was close to the center, so move it all the way to the
						// center
						[self moveCenterViewToCenterAnimated:YES easeIn:NO];
				}
			}
			
			break;
		}
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStatePossible:
		default:
			break;
	}
}

//// Tapping on transparent overlay
//- (void)tappedOnOverlayView:(UITapGestureRecognizer *)gesture
//{
//	if(![self menuDrawerIsHidden])
//		[self hideMenuDrawerAnimated:YES includingOverlay:YES]; // If not hidden, hide it
//	if(![self filterDrawerIsHidden])
//		[self hideFilterDrawerAnimated:YES includingOverlay:YES]; // If not hidden, hide it
//}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
