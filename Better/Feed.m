#import "Feed.h"

@interface Feed ()

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
	
	// Set up left/right drawer constraints
	// ...
	
	// Set up gesture recognizers for screen edges
	_leftEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureLeft:)];
	_rightEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRight:)];
	[[self leftEdgePanRecognizer] setEdges:UIRectEdgeLeft];
	[[self rightEdgePanRecognizer] setEdges:UIRectEdgeRight];
	[[self view] setGestureRecognizers:@[[self leftEdgePanRecognizer], [self rightEdgePanRecognizer]]];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Move the drawers off of the screen
	[[self menuLeadingConstraint] setConstant: -1 * [[self menuWidthConstraint] constant]];
	[[self filterTrailingConstraint] setConstant: -1 * [[self filterWidthConstraint] constant]];
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
		
	}
}

#pragma mark - Responding to bar button item presses
- (IBAction)menuButtonPressed:(id)sender
{
	// Toggle the Menu drawer
	if([[self menuLeadingConstraint] constant] != 0) // If Menu is not visible
		[[self menuLeadingConstraint] setConstant:0];
	else if([[self menuLeadingConstraint] constant] == 0) // If Menu is visible
		[[self menuLeadingConstraint] setConstant: -1 * [[self menuWidthConstraint] constant]];
	
	// Animate the change in position
	[UIView animateWithDuration:ANIM_DURATION_DRAWER_FULLSLIDE
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 [[self view] layoutIfNeeded];
					 }
					 completion:nil];
}

- (IBAction)filterButtonPressed:(id)sender
{
	
}

#pragma mark - Gesture recognizers
// Swiping from left edge
- (void)swipeGestureLeft:(UIScreenEdgePanGestureRecognizer *)gesture
{
	// Get the position of the gesture
	CGPoint touchPoint = [gesture translationInView:[self view]];
	
	// Move the drawer according to the x-position of the gesture
	float currentConstant = [[self menuLeadingConstraint] constant];
	[[self menuLeadingConstraint] setConstant:(currentConstant + touchPoint.x)];
	
//	NSLog(@"screen edge left, x:%.1f", touchPoint.x);
}

// Swiping from right edge
- (void)swipeGestureRight:(UIScreenEdgePanGestureRecognizer *)gesture
{
	CGPoint touchPoint = [gesture translationInView:[self view]];
//	NSLog(@"screen edge right, x:%.1f", touchPoint.x);
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
@end
