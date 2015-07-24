//
//  Intro.m
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Intro.h"

@interface Intro ()
{
	// array of IntroPage objects (one for each page), which is a subclass of UIViewController
	NSArray *pages;
	
	// boolean to make sure this view controller only does the introductory fade-in once
	BOOL introFadeDone;
	
	// boolean that is set to false only by -unwindToIntro:, and controls whether the navigation bar uses
	// animation when being hidden (false means no animation).
	BOOL useAnimationWhenHidingNavBar;
    
    // If flag is set, the method -viewWillLayoutSubviews will call layoutSlideshowPageViewController
    BOOL alreadySetUpSlideshow;
}

//// Methods for fading a UIView in and out (setting alpha to 1 and 0)
//- (void)fadeInView:(UIView *)view;
//- (void)fadeOutView:(UIView *)view;

// Reference to a UIPageViewController that is created on-demand if the user is not logged in - this viewcontroller's
// view is added as a subview of this viewcontroller's view and the PageViewController as a child ViewController
@property (strong, nonatomic) UIPageViewController *pageViewControllerSlideshow;

// Called to initialize a UIPageViewController (does not add it as a subview, etc.)
- (void)initializeSlideshowPageViewController;
// Called to lay out the UIPageViewController and add constraints to it
- (void)layoutSlideshowPageViewController;

@end

@implementation Intro

#pragma mark - Initialization, maintenance

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	useAnimationWhenHidingNavBar = TRUE;
    alreadySetUpSlideshow = FALSE;
    
    // Set alphas of logo and Get Started button to zero
    [[self logo] setAlpha:0];
    [[self getStartedButton] setAlpha:0];
    
    // Get UserInfo shared object
    [self setUser:[UserInfo user]];
	
	// Set up the navigation bar for pre-login areas of app
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_NAVIGATION_BAR];
	[[[self navigationController] navigationBar] setTintColor:COLOR_NAVIGATION_TINT];
	[[[self navigationController] navigationBar] setTranslucent:NO];
	
	// Set up the backgroundImage UIImageView
	[[self backgroundImage] setClipsToBounds:YES]; // Make sure the image view does not display an image outside of its bounds
	[[self backgroundImage] setContentMode:UIViewContentModeScaleAspectFill];
    
    // Try to log in
    [SSKeychain setPassword:@"PASSWORD" forService:[[self user] keychainServiceName] account:@"MYACCOUNTNAME"];
    
    // Returns all accounts (i.e. usernames) under the  service
    NSArray *accounts = [SSKeychain accountsForService:[[self user] keychainServiceName]];
    if([accounts count] == 0) // There is nothing saved
    {
        // The default is FALSE/NO, but just making sure
        [[self user] setLoggedIn:NO];
        
        // Initialize the tutorial/slideshow
        [self initializeSlideshowPageViewController];
    }
    else if([accounts count] == 1) // There is one login password item
    {
        
    }
    else if([accounts count] > 1) // There's more than one login password item (??)
    {
        // Delete all existing accounts under 
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Hide the navigation bar when showing this view controller
	if(useAnimationWhenHidingNavBar)
		[[self navigationController] setNavigationBarHidden:YES animated:YES];
	else
	{
		// Used by -unwindToIntro: to prevent an unsightly animation when the user uses the 'Log Out' button
		// in the Settings area
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
		useAnimationWhenHidingNavBar = TRUE; // Reset the flag to use animation
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
//	 Fade in the Better logo first, and other UI elements after a delay, if this hasn't already happened once
//	if(!introFadeDone)
//	{
		[UIView animateWithDuration:ANIM_DURATION_INTRO
						 animations:^{
							 [[self logo] setAlpha:1];
						 } completion:^(BOOL finished) {
                             // Fade in if the pageviewcontroller was created
                             if([self pageViewControllerSlideshow] != nil)
                             {
                                 // Fade in Get Started and background image
                                 [UIView animateWithDuration:ANIM_DURATION_INTRO
                                                       delay:ANIM_DELAY_INTRO
                                                     options:UIViewAnimationOptionCurveEaseOut
                                                  animations:^{
                                                      [[[self pageViewControllerSlideshow] view] setAlpha:1];
                                                      [[self getStartedButton] setAlpha:1];
                                                      [[self backgroundImage] setAlpha:1];
                                                  }
                                                  completion:nil];
                             }
                             else // Show the Feed
                             {
                                 // Instantiate the Feed
                                 UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_FILENAME_FEED bundle:[NSBundle mainBundle]];
                                 Feed *feedViewController = [feedStoryboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_FEED];
                                 
                                 // Do a cross-fade animation when showing the feed
                                 [feedViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                 // Present it
                                 [self presentViewController:feedViewController animated:YES completion:nil];
                             }
                         }];
//	}
}

// Before layout has happened (called when showing or when navigation happens)
- (void)viewWillLayoutSubviews
{
    // Super
    [super viewWillLayoutSubviews];
    
    // Lay out the UIPageViewController if necessary
    if(!alreadySetUpSlideshow && ![[UserInfo user] isLoggedIn])
    {
        // Run the layout
        [self layoutSlideshowPageViewController];
        
        // Set the first background image to be shown
        IntroPage *page1 = [pages firstObject];
        [[self backgroundImage] setImage:[page1 image]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

#pragma mark - PageViewController datasource, delegate methods

// Called when the page view controller is moving to the previous page (to the left)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	// Find where the current index is at the moment
	unsigned int currentIndex = (unsigned int)[pages indexOfObject:viewController];
	
	if(currentIndex == 0) // Can't scroll left any more
		return nil;
	else
		return [pages objectAtIndex:(currentIndex - 1)];
}

// Called when the page view controller is moving to the next page (to the right)
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	// Find where the current index is at the moment
	unsigned int currentIndex = (unsigned int)[pages indexOfObject:viewController];
	
	if(currentIndex == [pages count] - 1) // Can't scroll right any more
		return nil;
	else
		return [pages objectAtIndex:(currentIndex + 1)];
}

// Start off the current index at zero, for the page indicator
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return 0;
}

// Tell the page indicator how many pages there are
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return [pages count];
}

// Creates an IntroPage instance (a subclass of UIViewController) given an IntroPageContent
// object which contains the three lines of text and a boolean which specifies whether the first line is a title or not
- (IntroPage *)generatePageWithPageContent:(IntroPageContent *)pageContent
{
	// If the storyboard is nil and we try to run -instantiateViewController... on it, the app will crash;
	// this code detects this, but also crashes the app anyway
	NSAssert([[self navigationController] storyboard], @"Instantiating a view controller but the storyboard is nil");
	
	// Create a new instance of the Intro Page view controller and set its UILabls
	NSString *storyboardID = ([pageContent firstLineIsTitle]) ? STORYBOARD_ID_INTROPAGE_TITLE : STORYBOARD_ID_INTROPAGE_NOTITLE;
	
	IntroPage *page = [[[self navigationController] storyboard] instantiateViewControllerWithIdentifier:storyboardID];
	[[page view] setBackgroundColor:[UIColor clearColor]];
	[[page textOne] setText:[pageContent firstLine]];
	[[page textTwo] setText:[pageContent secondLine]];
	[[page textThree] setText:[pageContent thirdLine]];
	[page setImage:[pageContent image]];
	
	return page;
}

// Called when the page view controller	completes a transition
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
//	NSLog(@"pageViewController animation occurred");
	
	// Only consider the situation where the user actually changed pages (completed == TRUE)
	if(completed)
	{
		// Retrieve the image from the currently-shown view controller
		
		if([[pageViewController viewControllers] count] != 1)
		{
			NSLog(@"size of UIPageViewController's viewController array is not one...");
			return;
		}
		
		// Get reference to the currently-shown IntroPage (view controller)
		IntroPage *currentPage = (IntroPage *)[pageViewController viewControllers][0];
		
		// Show or hide the Better logo depending on which view controller is currently being shown
		if(currentPage != pages[0] && [[self logo] alpha] == 1)
		{
			// Hide the logo
			[UIView animateWithDuration:ANIM_DURATION_INTRO
							 animations:^{
								 [[self logo] setAlpha:0];
							 }];
		}
		else if(currentPage == pages[0])
		{
			// Show the logo
			[UIView animateWithDuration:ANIM_DURATION_INTRO
							 animations:^{
								 [[self logo] setAlpha:1];
							 }];
		}
		
		// Change the image
		[UIView transitionWithView:[self backgroundImage]
						  duration:ANIM_DURATION_INTRO
						   options:UIViewAnimationOptionTransitionCrossDissolve
						animations:^{
							[[self backgroundImage] setImage:[currentPage image]];
						}
						completion:nil];
	}
}

//- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
//{
//	NSLog(@"pageViewController transition to view controllers, size: %i", (unsigned int)[pendingViewControllers count]);
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//	// Embed segues are called just once when the parent view controller loads the container view and sets up the view controller
//	// inside the container
//	if([[segue identifier] isEqualToString:STORYBOARD_ID_SEGUE_EMBED_INTRO])
//	{
//		
//	}
//}

// Called when the user wants to 'Log Out'.
// The method below goes within the view controller that you want to unwind TO (the destination), but in the
// storyboard, you ctrl-drag from the view controller icon to the exit icon of the view controller that you're
// unwinding FROM (the source). The source view controller is also the one that you'd call
// -performSegueWithIdentifier:sender inside, also.
//
// This gets called before -viewWillAppear, which is good
- (IBAction)unwindToIntro:(UIStoryboardSegue *)sender
{
	NSLog(@"Unwinding to intro");
	
	// Set the flag to prevent the navigation bar from using animation when it hides (normally we want this,
	// so the flag is reset to TRUE in -viewWillAppear:)
	useAnimationWhenHidingNavBar = FALSE;
    
    // Initialize the slideshow PageViewController if necessary
    if([self pageViewControllerSlideshow] == nil)
    {
        [self initializeSlideshowPageViewController]; // allocate
        [self layoutSlideshowPageViewController]; // constraints
        
        // Set the first background image to be shown
        IntroPage *page1 = [pages firstObject];
        [[self backgroundImage] setImage:[page1 image]];
    }
}

//- (void)pageControlValueChanged:(UIPageControl *)sender
//{
//	NSLog(@"** value changed in page control");
//}

#pragma mark - Tutorial/slideshow initialization
// Create a UIPageViewController if necessary
- (void)initializeSlideshowPageViewController
{
    // Initialize if necessary
    if(_pageViewControllerSlideshow == nil)
    {
        // Create a UIPageViewController
        _pageViewControllerSlideshow = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        // Delegate and datasource are this object
        [[self pageViewControllerSlideshow] setDelegate:self];
        [[self pageViewControllerSlideshow] setDataSource:self];
        
        // Create pages for the PageViewController
        // Populate the pages array with IntroPage objects (UIViewController subclass)
        //
        IntroPageContent *page1Content = [[IntroPageContent alloc] initWithFirstLine:@"Help each other become the"
                                                                          secondLine:@"best version of yourselves,"
                                                                           thirdLine:@"one day at a time."
                                                                    firstLineIsTitle:NO
                                                                               image:[UIImage imageNamed:IMAGE_TUTORIAL_SHOES_DARK]];
        
        
        IntroPageContent *page2Content = [[IntroPageContent alloc] initWithFirstLine:@"Cast Your Vote"
                                                                          secondLine:@"Simply tap to vote for the"
                                                                           thirdLine:@"better beauty choice."
                                                                    firstLineIsTitle:YES
                                                                               image:[UIImage imageNamed:IMAGE_TUTORIAL_SHOES_SPOT]];
        
        
        IntroPageContent *page3Content = [[IntroPageContent alloc] initWithFirstLine:@"Make Better Decisions"
                                                                          secondLine:@"Post your own style questions"
                                                                           thirdLine:@"and get immediate feedback."
                                                                    firstLineIsTitle:YES
                                                                               image:[UIImage imageNamed:IMAGE_TUTORIAL_POST]];
        
        IntroPageContent *page4Content = [[IntroPageContent alloc] initWithFirstLine:@"Rise in the Ranks"
                                                                          secondLine:@"Rise in the ranks to get"
                                                                           thirdLine:@"crowned as a beauty icon."
                                                                    firstLineIsTitle:YES
                                                                               image:[UIImage imageNamed:IMAGE_TUTORIAL_CROWN]];
        
        IntroPage *page1 = [self generatePageWithPageContent:page1Content];
        IntroPage *page2 = [self generatePageWithPageContent:page2Content];
        IntroPage *page3 = [self generatePageWithPageContent:page3Content];
        IntroPage *page4 = [self generatePageWithPageContent:page4Content];
        
        pages = [[NSArray alloc] initWithObjects: page1, page2, page3, page4, nil];
        
        // Set the first view controller to be presented (first page)
        [[self pageViewControllerSlideshow] setViewControllers:@[page1]
                                                     direction:UIPageViewControllerNavigationDirectionForward
                                                      animated:YES
                                                    completion:nil];
    }
}

// Lay out the UIPageViewController
- (void)layoutSlideshowPageViewController
{
    // Add as subview and child view controller
    UIPageViewController *pvc = [self pageViewControllerSlideshow];
    [self addChildViewController:pvc];
    [[self view] addSubview:[pvc view]];
    [pvc didMoveToParentViewController:self];
    
    // UIPageViewController's view properties
    [[pvc view] setTranslatesAutoresizingMaskIntoConstraints:NO]; // Use our own constraints
    [[pvc view] setAlpha:0]; // Hidden at first
    
    // Add some layout (align to left and right of superview)
    NSArray *leadingTrailingConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pvc]-0-|"
                                                                                  options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                  metrics:nil
                                                                                    views:@{@"pvc":[pvc view]}];
    
    // Align top to top of superview and bottom to top of the Get Started button
    NSArray *topBottom = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pvc]-0-[button]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:@{@"pvc":[pvc view],
                                                                           @"button":[self getStartedButton]}];
    
    // Apply the constraints
    [[self view] addConstraints:leadingTrailingConstraints];
    [[self view] addConstraints:topBottom];
    
    // Only run once
    alreadySetUpSlideshow = TRUE;
}

@end
