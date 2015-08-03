//
//  MyInformation.m
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyInformation.h"

@implementation MyInformation

#pragma mark - ViewController management

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set up this view and TableView colors
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up the navigation bar for the My Info area
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTranslucent:NO];
	
	// Get pointer to UserInfo
	UserInfo *user = [UserInfo user];
	
	// Set up profile image and panel
	[[[self profileImage] layer] setMasksToBounds:YES];
	[[[self profileImage] layer] setCornerRadius:[[self profileImage] frame].size.width / 2];
	if([user profileImage] == nil)
	{
		[[self profileImage] setImage:[UIImage imageNamed:@"donkey"]];
		[[self profilePanel] setImage:[UIImage imageNamed:@"donkey"]];
	}
	
	// Set up profile panel overlay (tint)
	[[self profilePanelOverlay] setBackgroundColor:COLOR_BETTER_DARK];
	[[self profilePanelOverlay] setAlpha:ALPHA_PROFILE_PANEL_OVERLAY];
	
	// Set up view controller title
	[self setTitle:[user username]];
	
	// Set up rank
	switch([[user rank] rank])
	{
		case RANK_NORANK:
			[[self rankLabel] setText:@""];
			[[self rankIcon] setImage:nil];
			break;
		case RANK_NOOB:
			[[self rankLabel] setText:@"Newbie"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE_WHITE]];
			break;
		case RANK_MAINSTREAM:
			[[self rankLabel] setText:@"Mainstream"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM_WHITE]];
			break;
		case RANK_TRAILBLAZER:
			[[self rankLabel] setText:@"Trailblazer"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER_WHITE]];
			break;
		case RANK_TRENDSETTER:
			[[self rankLabel] setText:@"Trendsetter"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER_WHITE]];
			break;
		case RANK_CROWNED:
			[[self rankLabel] setText:@"Crowned"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED_WHITE]];
			break;
	}
	
	// Set up user age, sex, and country
	NSString *ageGender = [NSString stringWithFormat:@"%i%c", [user getAge], ([user gender] == GENDER_FEMALE) ? 'F' : 'M'];
	[[self ageAndGenderLabel] setText:ageGender];
	
	// Country
	[[self countryLabel] setText:[user getCountry]];
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

//- (IBAction)cycleRankIcon:(id)sender
//{
//	currentIcon++;
//	currentIcon %= 6;
//	[[[UserInfo user] rank] setRank:currentIcon];
//	
//	switch(currentIcon)
//	{
//		case 0:
//			[[self rankLabel] setText:@""];
//			[[self rankIcon] setImage:nil];
//			break;
//		case 1:
//			[[self rankLabel] setText:@"Newbie"];
//			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE_WHITE]];
//			break;
//		case 2:
//			[[self rankLabel] setText:@"Mainstream"];
//			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM_WHITE]];
//			break;
//		case 3:
//			[[self rankLabel] setText:@"Trailblazer"];
//			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER_WHITE]];
//			break;
//		case 4:
//			[[self rankLabel] setText:@"Trendsetter"];
//			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER_WHITE]];
//			break;
//		case 5:
//			[[self rankLabel] setText:@"Crowned"];
//			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED_WHITE]];
//			break;
//	}
//}

@end
