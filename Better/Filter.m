//
//  FilterViewController.m
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Filter.h"

@interface FilterViewController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Detecting taps
- (void)tappableViewTapped:(BETappableView *)view withGesture:(UITapGestureRecognizer *)gesture
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
