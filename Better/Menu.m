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
	
	// Set the profile image
	[[[self profileImageView] layer] setMasksToBounds:YES];
	//	[[[self profileImageView] layer] setShouldRasterize:YES]; // For performance?
	[[[self profileImageView] layer] setCornerRadius:[[self profileImageView] frame].size.height / 2];
	[[self profileImageView] setImage:[UIImage imageNamed:@"donkey"]];

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
	}
	else if(view == [self myRankingView])
	{
		NSLog(@"tapped inside My Ranking area");
	}
	else if(view == [self settingsView])
	{
		NSLog(@"tapped inside Settings area");
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
