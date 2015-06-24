//
//  BEPageViewController.m
//  Better
//
//  Created by Peter on 6/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEPageViewController.h"

@interface BEPageViewController ()
{
	// Keeps track of current page
	unsigned int currentPage;
}

// This class is kind of limited in that you can only set the viewControllers all at once, as opposed
// to the UIPageViewController which is more dynamic and loads the view controllers only when needed.

// Array of viewcontrollers to present on the screen
@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation BEPageViewController

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Initialize vars
	currentPage = 0;
	
	// Set up scrollview
	[[self scrollView] setPagingEnabled:YES];
	[[self scrollView] setScrollsToTop:NO];
	[[self scrollView] setBounces:NO];
	[[self scrollView] setShowsHorizontalScrollIndicator:NO];
	[[self scrollView] setShowsVerticalScrollIndicator:NO];
	[[self scrollView] setDelegate:self];
	
	// Get the viewcontrollers from the datasource
	if([self dataSource] && [[self dataSource] respondsToSelector:@selector(viewControllersForPageViewController:)])
		_viewControllers = [[[self dataSource] viewControllersForPageViewController:self] copy];
	
	// Don't show anything if viewControllers is nil
	if(_viewControllers == nil)
		return;
	
	// Remove previous viewcontrollers and subviews
//	for(UIViewController *vc in [self childViewControllers])
//	{
//		[[vc view] removeFromSuperview];
//		[vc removeFromParentViewController];
//	}
//	
//	// Delete all of the scrollview's existing constraints
//	[[self scrollView] removeConstraints:[[self scrollView] constraints]];
	
	// Add the viewcontrollers as children of this viewcontroller
	for(UIViewController *vc in _viewControllers)
	{
		[self addChildViewController:vc];
		[vc didMoveToParentViewController:self];
	}
	
	// Add the subviews and generate constraints for them
	//	NSMutableArray *subviewConstraints = [[NSMutableArray alloc] init];
	for(unsigned int i = 0; i < [[self childViewControllers] count]; i++)
	{
		// Get the subviews
		UIViewController *vc = [[self childViewControllers] objectAtIndex:i];
		UIView *vcView = [vc view];
		
		// Set properties
		[vcView setTranslatesAutoresizingMaskIntoConstraints:NO]; // Use our own constraints
		[[self scrollView] addSubview:vcView]; // Add it to the scrollview
		
		// Generate top, height, and width constraints
		NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:vcView
															   attribute:NSLayoutAttributeTop
															   relatedBy:NSLayoutRelationEqual
																  toItem:[self scrollView]
															   attribute:NSLayoutAttributeTop
															  multiplier:1 constant:0];
		NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:vcView
																  attribute:NSLayoutAttributeHeight
																  relatedBy:NSLayoutRelationEqual
																	 toItem:[self scrollView]
																  attribute:NSLayoutAttributeHeight
																 multiplier:1 constant:0];
		NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:vcView
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:[self scrollView]
																 attribute:NSLayoutAttributeWidth
																multiplier:1 constant:0];
		[[self scrollView] addConstraint:top];
		[[self scrollView] addConstraint:height];
		[[self scrollView] addConstraint:width];
		
		// Generate leading and trailing constraints:
		// First subview
		if(i == 0)
		{
			NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:vcView
																	   attribute:NSLayoutAttributeLeading
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:[self scrollView]
																	   attribute:NSLayoutAttributeLeading
																	  multiplier:1 constant:0];
			[[self scrollView] addConstraint:leading];
		}
		// Second subview through second-to-last subview
		else if(i > 0 && i < ([[self childViewControllers] count] - 1))
		{
			// Retrieve the previous viewcontroller's view
			UIViewController *previousVC = [[self childViewControllers] objectAtIndex:(i-1)];
			UIView *previousVCView = [previousVC view];
			
			// Generate a constraint to tie the current view and the previous view together
			NSLayoutConstraint *between = [NSLayoutConstraint constraintWithItem:previousVCView
																	   attribute:NSLayoutAttributeTrailing
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:vcView
																	   attribute:NSLayoutAttributeLeading
																	  multiplier:1 constant:0];
			[[self scrollView] addConstraint:between];
		}
		// Last subview (can include 2nd to last subview)
		else if(i == ([[self childViewControllers] count] - 1))
		{
			// Retrieve the previous viewcontroller's view
			UIViewController *previousVC = [[self childViewControllers] objectAtIndex:(i-1)];
			UIView *previousVCView = [previousVC view];
			
			// Generate a constraint to tie the current view and the previous view together
			NSLayoutConstraint *between = [NSLayoutConstraint constraintWithItem:previousVCView
																	   attribute:NSLayoutAttributeTrailing
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:vcView
																	   attribute:NSLayoutAttributeLeading
																	  multiplier:1 constant:0];
			[[self scrollView] addConstraint:between];
			
			// Generate constraint to tie the last subview's right side to the right side of the scrollview's
			// content
			NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:vcView
																		attribute:NSLayoutAttributeTrailing
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self scrollView]
																		attribute:NSLayoutAttributeTrailing
																	   multiplier:1 constant:0];
			[[self scrollView] addConstraint:trailing];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when another object wants to change the viewcontrollers that are being displayed by this object
//- (void)setViewControllers:(NSArray *)viewControllers
//{
//	// Set new controllers
//	_viewControllers = viewControllers;
//	
//	
//}

#pragma mark - UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	// Stop if there's no delegate
	if(![self delegate])
		return;
	
	// Update the page when more than 50% of the previous/next page is visible
	// `page` is '0' for the first page, '1' for the second page, etc.
	CGFloat pageWidth = self.scrollView.frame.size.width;
	unsigned int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	// Notify the delegate if there was a change
	if([[self delegate] respondsToSelector:@selector(pageViewController:switchedToPage:)])
	{
		if(page != currentPage)
		{
			[[self delegate] pageViewController:self switchedToPage:page];
			currentPage = page;
		}
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
