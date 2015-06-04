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
- (void)tappedProfileArea:(UITapGestureRecognizer *)gesture;
- (void)tappedMyRanking:(UITapGestureRecognizer *)gesture;
- (void)tappedSettings:(UITapGestureRecognizer *)gesture;

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
	[[self usernameLabel] setText:@"Donkey"];
	
	// Set up gesture recognizers
	UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedProfileArea:)];
	UITapGestureRecognizer *myRankTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMyRanking:)];
	UITapGestureRecognizer *settingsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSettings:)];
	[[self profileView] addGestureRecognizer:profileTap];
	[[self myRankingView] addGestureRecognizer:myRankTap];
	[[self settingsView] addGestureRecognizer:settingsTap];
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

#pragma mark - Gesture recognizer methods
// Called when user taps within the profile area (image, background)
- (void)tappedProfileArea:(UITapGestureRecognizer *)gesture
{
	NSLog(@"tapped inside Profile area");
}

// Called when user taps within the My Ranking view
- (void)tappedMyRanking:(UITapGestureRecognizer *)gesture
{
	NSLog(@"tapped inside My Ranking");
}

// Called when user taps within Settings view
- (void)tappedSettings:(UITapGestureRecognizer *)gesture
{
	NSLog(@"tapped inside Settings");
}

@end
