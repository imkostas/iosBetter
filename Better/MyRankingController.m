//
//  MyRanking.m
//  Better
//
//  Created by Peter on 6/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyRankingController.h"

@interface MyRankingController ()
{
	// Array to hold the two child view-controllers (My Ranking, Leaderboard)
	NSArray *pages;
}

@end

@implementation MyRankingController

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	// Set up the navigation bar for the Ranking area
//	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[[[self navigationController] navigationBar] setTranslucent:NO];
	[[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:IMAGE_PIXEL_COLOR_BETTER_DARK] forBarMetrics:UIBarMetricsDefault];
	[[[self navigationController] navigationBar] setShadowImage:[UIImage imageNamed:IMAGE_PIXEL_TRANSPARENT]];
	
	// Set up page seg.control and background view
//	[[self pageSegmentedControl] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:FONT_SIZE_SEGMENTED_CONTROL]} forState:UIControlStateNormal];
	[[self segControlBackground] setBackgroundColor:COLOR_BETTER_DARK];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSLog(@"**********MyRankingController will appear");
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSLog(@"********MyRankingController did appear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	 
	 // Get the page view controller as it's being embedded
	 if([[segue identifier] isEqualToString:STORYBOARD_ID_SEGUE_EMBED_RANKING])
	 {
		 // Get the BEPageViewController destination
		 BEPageViewController *pageViewController = (BEPageViewController *)[segue destinationViewController];
		 [pageViewController setDataSource:self];
		 [pageViewController setDelegate:self];
		 [self setPageViewController:pageViewController]; // Save reference to this
		 
		 // Generate view controllers to use as pages
		 if([self storyboard])
		 {
			 MyRanking *myRankVC = (MyRanking *)[[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_MYRANKING];
			 Leaderboard *leaderboardVC = (Leaderboard *)[[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_LEADERBOARD];
			 pages = [NSArray arrayWithObjects:myRankVC, leaderboardVC, nil];
		 }
	 }
}

// Called upon back arrow press
- (IBAction)backArrowPressed:(id)sender
{
	// Go back to Feed
	[self dismissViewControllerAnimated:YES completion:nil];
}

// Called on switch of segmented control
- (IBAction)segControlValueChanged:(UISegmentedControl *)sender
{
	// Scroll to the correct position in the BEPageViewController's scrollview
	CGPoint scrollViewTargetOffset;
	scrollViewTargetOffset.x = CGRectGetWidth([[[self pageViewController] scrollView] frame]) * [sender selectedSegmentIndex];
	scrollViewTargetOffset.y = 0;
	
	[[[self pageViewController] scrollView] setContentOffset:scrollViewTargetOffset animated:YES];
}

#pragma mark - PageViewController datasource methods
- (NSArray *)viewControllersForPageViewController:(BEPageViewController *)pageViewController
{
	return pages;
}

#pragma mark - PageViewController delegate methods
- (void)pageViewController:(BEPageViewController *)pageViewController switchedToPage:(NSInteger)page
{
	// Change the segmented control's currently-selected button
	if(page >= 0 && page < [[self pageSegmentedControl] numberOfSegments])
	{
		// Do a fading animation when changing the selected segment
		[UIView transitionWithView:[self pageSegmentedControl]
						  duration:ANIM_DURATION_SEGMENTED_CONTROL_SWITCH
						   options:UIViewAnimationOptionTransitionCrossDissolve
						animations:^{
							[[self pageSegmentedControl] setSelectedSegmentIndex:page];
						}
						completion:nil];
	}
}

@end
