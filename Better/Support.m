//
//  Support.m
//  Better
//
//  Created by Peter on 6/11/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Support.h"

@interface Support ()

@end

@implementation Support

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Set background color of TableView
	[[super tableView] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Get index of selected row
//	NSLog(@"selected row: %i", [indexPath indexAtPosition:1]);
	
	// Perform different actions based on which row was selected
	switch([indexPath indexAtPosition:1])
	{
		case 0: // Send feedback
		{
			// Check if the device supports MFMailComposeViewController
			if([MFMailComposeViewController canSendMail])
			{
				// Show an interface for send an email to Better
				MFMailComposeViewController *emailViewController = [[MFMailComposeViewController alloc] init];
				
				// Set properties
				[emailViewController setMailComposeDelegate:self];
				[emailViewController setSubject:@"Better Feedback"];
				[emailViewController setToRecipients:@[@"support@better.com"]];
	//			[[emailViewController view] setTintColor:[UIColor whiteColor]]; // Sets color of 'Cancel' and 'Send' button

				// Show the email composer
				[self presentViewController:emailViewController animated:YES completion:nil];
			}
			else // Can't send for some reason :-/
			{
				// Should find a better way to do this, maybe once we decide on a custom alert look
				UIAlertView *noMailAlert = [[UIAlertView alloc] initWithTitle:@"Unfortunately, your device does not support email."
																	  message:@"You can always contact us through your personal email client at support@betterapp.com"
																	 delegate:nil
															cancelButtonTitle:@"OK"
															otherButtonTitles:nil];
				[noMailAlert show];
			}
			
			break;
		}
		case 1: // Rate BETTER
		{
			NSLog(@"yo");
			break;
		}
		case 2: // Privacy Policy
		{
			// 'Show' segue
			[self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_SHOW_SUPPORT_TERMSPRIVACY sender:self];
			break;
		}
		case 3: // Terms of Service
		{
			// 'Show' segue
			[self performSegueWithIdentifier:STORYBOARD_ID_SEGUE_SHOW_SUPPORT_TERMSPRIVACY sender:self];
			break;
		}
		default:
			break;
	}
	
	// Deselect (de-highlight) the row
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MFMailCompose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	// Doesn't matter what happened with the message (don't check result or error) (?)
	[controller dismissViewControllerAnimated:YES completion:nil];
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
