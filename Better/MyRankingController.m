//
//  MyRanking.m
//  Better
//
//  Created by Peter on 6/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyRankingController.h"

@interface MyRankingController ()

@end

@implementation MyRankingController

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	// Set up the navigation bar for the Ranking area
//	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
//	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
//	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//	[[[self navigationController] navigationBar] setTranslucent:NO];
//	
//	// Background color of this view and of Rank bar
//	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
//	[[self rankBar] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
//	
//	// Set corner radius on profile picture
//	[[[self profilePicture] layer] setMasksToBounds:YES];
//	[[[self profilePicture] layer] setCornerRadius:[[self profilePicture] frame].size.height / 2];
//	
//	// Set up profile picture
//	if([[UserInfo user] profileImage] == nil)
//	{
//		// Default images
//		[[self profilePanel] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE]];
//		[[self profilePicture] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE]];
//	}
//	
//	// Set up the crown icon (next to rank bar)
//	[[self crownedIcon] setImage:[UIImage imageNamed:ICON_CROWN_UNFILLED]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
