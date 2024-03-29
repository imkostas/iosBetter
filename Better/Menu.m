//
//  Menu.m
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Menu.h"

@interface MenuViewController ()

// Methods for tap gesture recognizers to detect pressing on profile area, My Ranking, and Settings
//- (void)tappedProfileArea:(UITapGestureRecognizer *)gesture;
//- (void)tappedMyRanking:(UITapGestureRecognizer *)gesture;
//- (void)tappedSettings:(UITapGestureRecognizer *)gesture;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Set background color of view
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up the scrollview
	//
	// Disable scrolls-to-top feature for Menu (it's unecessary and the scrollview that actually needs it
	// is the Feed's UITableView which displays all of the posts)
	[[self scrollView] setScrollsToTop:NO];
	
	// Set the profile image
	[[[self profileImageView] layer] setMasksToBounds:YES];
	[[[self profileImageView] layer] setCornerRadius:[[self profileImageView] frame].size.height / 2];
	[[self profileImageView] setImage:[UIImage imageNamed:@"donkey"]];
	
	// Set profile panel / background
	if([[UserInfo user] profileImage] == nil)
		[[self profilePanelView] setImage:[UIImage imageNamed:@"donkey"]];
	
	// Profile panel overlay
	[[self profilePanelViewOverlay] setBackgroundColor:COLOR_BETTER_DARK];
	[[self profilePanelViewOverlay] setAlpha:ALPHA_PROFILE_PANEL_OVERLAY];

	// Set the username label
	[[self usernameLabel] setText:[[UserInfo user] username]];
	NSLog(@"username in menu: %@", [[UserInfo user] username]);
	
	// Set delegate of Tappable Views to this object
	[[self profileView] setDelegate:self];
	[[self myRankingView] setDelegate:self];
	[[self settingsView] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Detecting taps
// Called when the user taps within the two tappable areas (My Ranking, Settings)
- (void)tappableViewTapped:(BETappableView *)view withGesture:(UITapGestureRecognizer *)gesture
{
	if(view == [self profileView])
	{
		NSLog(@"tapped inside Profile area");
		
		// Show the "My Information" view controller
		if([self storyboard])
		{
			UINavigationController *myInfoController = [[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_MYINFORMATION_NAVIGATION];
			[[self parentViewController] presentViewController:myInfoController animated:YES completion:nil];
		}
	}
	else if(view == [self myRankingView])
	{
		NSLog(@"tapped inside My Ranking area");
		
		// Show the My Ranking view controller
		if([self storyboard])
		{
			UINavigationController *myRankingController = [[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_MYRANKING_NAVIGATION];
			[[self parentViewController] presentViewController:myRankingController animated:YES completion:nil];
		}
	}
	else if(view == [self settingsView])
	{
		NSLog(@"tapped inside Settings area");
		
		// Show the settings view controller
//		if([self storyboard]) // Make sure storyboard exists
//		{
//			UINavigationController *settingsController = [[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_SETTINGS_NAVIGATION];
//			[[self parentViewController] presentViewController:settingsController animated:YES completion:nil];
//		}
		// Load it from Settings.storyboard
		UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:STORYBOARD_FILENAME_SETTINGS bundle:[NSBundle mainBundle]];
		if(settingsStoryboard != nil)
		{
			UINavigationController *settingsController = [settingsStoryboard instantiateViewControllerWithIdentifier:STORYBOARD_ID_SETTINGS_NAVIGATION];
			[[self parentViewController] presentViewController:settingsController animated:YES completion:nil];
		}
	}
}

//#pragma mark - Gesture recognizer methods
// Called when user taps within the profile area (image, background)
//- (void)tappedProfileArea:(UITapGestureRecognizer *)gesture
//{
//	NSLog(@"tapped inside Profile area");
//}
//
//// Called when user taps within the My Ranking view
//- (void)tappedMyRanking:(UITapGestureRecognizer *)gesture
//{
//	NSLog(@"tapped inside My Ranking");
//}
//
//// Called when user taps within Settings view
//- (void)tappedSettings:(UITapGestureRecognizer *)gesture
//{
//	NSLog(@"tapped inside Settings");
//}

@end
