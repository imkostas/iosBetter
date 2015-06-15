//
//  MyInformation.m
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyInformation.h"

@interface MyInformation ()

@end

@implementation MyInformation

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set up the navigation bar for the My Info area
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[[[self navigationController] navigationBar] setTranslucent:NO];
	
	// Get pointer to UserInfo
	UserInfo *user = [UserInfo user];
	
	// Set up profile image and panel
	[[[self profileImage] layer] setMasksToBounds:YES];
	[[[self profileImage] layer] setCornerRadius:[[self profileImage] frame].size.width / 2];
	if([user profileImage] == nil)
	{
		[[self profileImage] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE]];
		[[self profilePanel] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE]];
	}
	
	// Set up view controller title
	[self setTitle:[user username]];
	
	// Set up rank and user info
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Bar button item presses
- (IBAction)backArrowPressed:(id)sender
{
	// Dismiss this view controller, go back to the feed
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)settingsButtonPressed:(id)sender
{
	// Open the Settings area
}
@end
