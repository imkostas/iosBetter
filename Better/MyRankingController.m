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
		 // Set delegate and datasource to this object
		 UIPageViewController *rankingPageViewController = (UIPageViewController *)[segue destinationViewController];
		 [rankingPageViewController setDataSource:self];
		 [rankingPageViewController setDelegate:self];
		 
		 // Generate view controllers to use as pages
		 if([self storyboard])
		 {
			 NSLog(@"generating pages");
			 MyRanking *myRankVC = (MyRanking *)[[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_MYRANKING];
			 Leaderboard *leaderboardVC = (Leaderboard *)[[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_LEADERBOARD];
			 pages = [NSArray arrayWithObjects:myRankVC, leaderboardVC, nil];
			 
			 // Set the first view controller to be presented (first page)
			 [rankingPageViewController setViewControllers:@[myRankVC]
												 direction:UIPageViewControllerNavigationDirectionForward
												  animated:YES
												completion:nil];
		 }
	 }
}

// Called upon back arrow press
- (IBAction)backArrowPressed:(id)sender
{
	// Go back to Feed
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PageViewController datasource methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSLog(@"Hello 1");
	
	int currentIndex = [pages indexOfObject:viewController];
	
	if(currentIndex <= 0)
		return nil;
	else
		return [pages objectAtIndex:(currentIndex - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSLog(@"hello 2");
	
	int currentIndex = [pages indexOfObject:viewController];
	
	if(currentIndex >= [pages count] - 1)
		return nil;
	else
		return [pages objectAtIndex:(currentIndex + 1)];
}

@end
