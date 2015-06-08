//
//  FilterViewController.m
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Filter.h"

@interface FilterViewController ()

- (void)dismissSearch;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set the delegate of the BETappableViews to this object
	[[self everythingView] setDelegate:self];
	[[self favoriteTagsView] setDelegate:self];
	[[self followingView] setDelegate:self];
	[[self trendingView] setDelegate:self];
	
//	UITapGestureRecognizer *hey = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearch)];
//	[[self view] addGestureRecognizer:hey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Detecting taps
- (void)tappableViewTapped:(BETappableView *)view withGesture:(UITapGestureRecognizer *)gesture
{
	// Get rid of keyboard
	[self dismissSearch];
	
	// Tell the delegate (the Feed) that the filter has changed
	if([self delegate] != nil)
	{
		if(view == [self everythingView])
			[[self delegate] filterChanged:@"Everything"];
		else if(view == [self favoriteTagsView])
			[[self delegate] filterChanged:@"Favorite Tags"];
		else if(view == [self followingView])
			[[self delegate] filterChanged:@"Following"];
		else if(view == [self trendingView])
			[[self delegate] filterChanged:@"Trending"];
	}
}

#pragma mark - Handling the UISearchBar
// Called when the search bar begins editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// Show the "Cancel" button next to the search bar
	[[self searchBar] setShowsCancelButton:YES animated:YES];
	
	// Notify Feed that searching began
	if([self delegate] != nil)
		[[self delegate] filterSearchDidBegin:searchBar];
}

// Called when the search bar ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	// Hide the "Cancel" button next to the search bar
//	[[self searchBar] setShowsCancelButton:NO animated:YES];
	
	// Notify Feed that searching ended
//	if([self delegate] != nil)
//		[[self delegate] filterSearchDidEnd:searchBar];
}

// Called when the "Cancel" button is pressed (Not the little "x")
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// Remove focus from search bar
	[searchBar resignFirstResponder];
	
	// Hide the "Cancel" button next to the search bar
	[[self searchBar] setShowsCancelButton:NO animated:YES];
	
	// Notify Feed that searching ended
		if([self delegate] != nil)
			[[self delegate] filterSearchDidEnd:searchBar];
}

// Called when the "Search" button on the keyboard is pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSLog(@"* Would perform a search here *");
	[searchBar resignFirstResponder];
}

// Get rid of the keyboard
- (void)dismissSearch
{
	[[self searchBar] resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
