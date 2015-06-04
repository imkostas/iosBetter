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
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self setTitle:@"Everything"];
	
	// Set view properties
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up gesture recognizers for screen edges
	_leftEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureLeft:)];
	_rightEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRight:)];
	[[self leftEdgePanRecognizer] setEdges:UIRectEdgeLeft];
	[[self rightEdgePanRecognizer] setEdges:UIRectEdgeRight];
	[[self view] setGestureRecognizers:@[[self leftEdgePanRecognizer], [self rightEdgePanRecognizer]]];
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

#pragma mark - Gesture recognizers
// Swiping from left edge
- (void)swipeGestureLeft:(UIScreenEdgePanGestureRecognizer *)gesture
{
	CGPoint touchPoint = [gesture translationInView:[self view]];
	NSLog(@"screen edge left, x:%.1f", touchPoint.x);
}

// Swiping from right edge
- (void)swipeGestureRight:(UIScreenEdgePanGestureRecognizer *)gesture
{
	CGPoint touchPoint = [gesture translationInView:[self view]];
	NSLog(@"screen edge right, x:%.1f", touchPoint.x);
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
