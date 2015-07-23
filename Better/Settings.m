//
//  Settings.m
//  Better
//
//  Created by Peter on 6/9/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set up the navigation bar for the Settings area
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTranslucent:NO];
	
	// Set the delegate of the tappable areas to this object
	[[self myAccountView] setDelegate:self];
	[[self notificationsView] setDelegate:self];
	[[self supportView] setDelegate:self];
	[[self logoutView] setDelegate:self];
	
	// Set background color of this view
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TappableView delegate method
- (void)tappableViewTapped:(BETappableView *)view withGesture:(UITapGestureRecognizer *)gesture
{
	// Perform segues/actions based on which view was tapped on
	if(view == [self myAccountView])
		[self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_SHOW_SETTINGS_MYACCOUNT sender:self];
	
	else if(view == [self notificationsView])
		[self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_SHOW_SETTINGS_NOTIFICATIONS sender:self];
	
	else if(view == [self supportView])
		[self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_SHOW_SETTINGS_SUPPORT sender:self];
	
	else if(view == [self logoutView])
	{
		/*
		// Initialize a custom alert
		CustomAlert *alert = [[CustomAlert alloc] initWithType:2 withframe:[[self view] frame] withMessage:@"Are you sure you want to log out?"];
		[alert setCustomAlertDelegate:self]; // Set alert delegate to this object
		
		// Set up buttons
		[[alert leftButton] setTitle:@"No" forState:UIControlStateNormal];
		[[alert rightButton] setTitle:@"Yes" forState:UIControlStateNormal];
		
		[self setLogoutAlert:alert]; // Save a reference to the alert
		[[self view] addSubview:alert]; // Add to view hierarchy
		[UIView animateWithDuration:ANIM_DURATION_ALERT_SHOW animations:^{[alert setAlpha:1];}]; // Fade-in*/

		// Show an alert for logging out
		if([UIAlertController class]) // UIAlertController is not available before iOS 8
		{
			UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?"
																				 message:nil
																		  preferredStyle:UIAlertControllerStyleAlert];
			[logoutAlert addAction:[UIAlertAction actionWithTitle:@"No"
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction *action) {
															  NSLog(@"Logout canceled");
														  }]];
			[logoutAlert addAction:[UIAlertAction actionWithTitle:@"Yes"
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction *action) {
                                                              // Set logged out state
                                                              [[UserInfo user] setLoggedIn:NO];
                                                              
															  // Use unwind segue to go back to Intro
															  [self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_UNWIND_TO_INTRO sender:self];
														  }]];
			// Show the alert
			[self presentViewController:logoutAlert animated:YES completion:nil];
			
			// Set its tint color (changes the font color of the buttons)
			[[logoutAlert view] setTintColor:COLOR_BETTER_DARK];
		}
		else
		{
			UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to log out?"
																  message:nil
																 delegate:self
														cancelButtonTitle:nil
														otherButtonTitles:@"No", @"Yes", nil];
			[logoutAlert show];
		}
	}
}

// For iOS 7's UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"])
    {
        // Use unwind segue to go back to Intro
        [self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_UNWIND_TO_INTRO sender:self];
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


/*#pragma mark - CustomAlert delegate methods
- (void)leftActionMethod:(int)method
{
	//hide custom alert and remove it from its superview
	[UIView animateWithDuration:ANIM_DURATION_ALERT_HIDE animations:^{
		
		[[self logoutAlert] setAlpha:0.0f];
		
	} completion:^(BOOL finished) {
		
		[[self logoutAlert] removeFromSuperview];
		
	}];
}

- (void)rightActionMethod:(int)method
{
	//hide custom alert and remove it from its superview
	[UIView animateWithDuration:ANIM_DURATION_ALERT_HIDE animations:^{
		
		[[self logoutAlert] setAlpha:0.0f];
		
	} completion:^(BOOL finished) {
		
		[[self logoutAlert] removeFromSuperview];
		
		////// ***** Logout here ***** //////
		
	}];
}*/

#pragma mark - Navigation bar buttons
// Called when back arrow is pressed
- (IBAction)backArrowPressed:(id)sender
{
	// Dismiss this view controller (shows the Feed again)
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
