#import "MainVController.h"

@interface MainVController ()

@end

@implementation MainVController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Set up the 'navigation bar'
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	
	// Set up gesture recognizers for screen edges
	_leftEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureLeft:)];
	_rightEdgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRight:)];
	[[self leftEdgePanRecognizer] setEdges: UIRectEdgeLeft];
	[[self rightEdgePanRecognizer] setEdges: UIRectEdgeRight];
	[[self view] setGestureRecognizers:@[[self leftEdgePanRecognizer], [self rightEdgePanRecognizer]]];
}

// Swiping from left edge
- (void)swipeGestureLeft:(UIGestureRecognizer *)gesture
{
	NSLog(@"screen edge left");
}

// Swiping from right edge
- (void)swipeGestureRight:(UIGestureRecognizer *)gesture
{
	NSLog(@"screen edge right");
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
