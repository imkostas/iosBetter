//
//  MyInformation.m
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyInformation.h"

@interface MyInformation ()
{
	int currentIcon;
}

@end

@implementation MyInformation

#pragma mark - ViewController management

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	currentIcon = 0;
	
	// Set up this view and TableView colors
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	[[self countsTableView] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up the navigation bar for the My Info area
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_NAVIGATION_BAR]}];
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
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE]];
			break;
		case RANK_MAINSTREAM:
			[[self rankLabel] setText:@"Mainstream"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM]];
			break;
		case RANK_TRAILBLAZER:
			[[self rankLabel] setText:@"Trailblazer"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER]];
			break;
		case RANK_TRENDSETTER:
			[[self rankLabel] setText:@"Trendsetter"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER]];
			break;
		case RANK_CROWNED:
			[[self rankLabel] setText:@"Crowned"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED]];
			break;
	}
	
	// Set up user age, sex, and country
	NSString *ageGender = [NSString stringWithFormat:@"%i%c", [user getAge], ([user gender] == GENDER_FEMALE) ? 'F' : 'M'];
	[[self ageAndGenderLabel] setText:ageGender];
	
	// Country
	[[self countryLabel] setText:[user getCountry]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Load user's counts
	[self getCounts];
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

#pragma mark - UITableView data source methods
// Called to determine the sections of the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
	
//	switch(section)
//	{
//		case 0:
//			return 1;
//		case 1:
//			return 1;
//		case 2:
//			return 2;
//		case 3:
//			return 2;
//		default:
//			return 0;
//	}
}
//
//// Called to determine how many sections the tableview has (4)
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return 4;
//}

// Called when the tableview wants to load a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Get a custom cell, or initialize one if it hasn't been init-ed yet
	MyInfoTableViewCell *cell = (MyInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_MYINFORMATION_TABLECELL];
	
	if(cell == nil)
	{
		[tableView registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:REUSE_ID_MYINFORMATION_TABLECELL];
		cell = (MyInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_MYINFORMATION_TABLECELL];
	}
	
	return cell;
}

// Called when a cell is about to appear (we set its properties here)
- (void)tableView:(UITableView *)tableView willDisplayCell:(MyInfoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Get pointer to UserInfo to get the counts object
	UserInfo *user = [UserInfo user];
	UserCounts *counts = [user counts];
	
	// Return cells based on the index path (non-grouped)
	switch ([indexPath indexAtPosition:1]) // position 0 is always zero (section zero)
	{
		case 0:
			[[cell label] setText:@"My Votes"];
			[[cell count] setText:[[counts myVotes] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_CHECKMARK]];
			break;
		case 1:
			[[cell label] setText:@"My Posts"];
			[[cell count] setText:[[counts myPosts] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_PORTRAIT]];
			break;
		case 2:
			[[cell label] setText:@"Favorite Posts"];
			[[cell count] setText:[[counts favoritePosts] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_FAVORITE_OUTLINE]];
			// Remove the separator from below this cell
			// --> UIEdgeInsetsMake(top, left, bottom, right)
			[cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth([cell frame]), 0, 0)];
			break;
		case 3:
			[[cell label] setText:@"Favorite Tags"];
			[[cell count] setText:[[counts favoriteTags] stringValue]];
			[[cell icon] setImage:nil];
			break;
		case 4:
			[[cell label] setText:@"Following"];
			[[cell count] setText:[[counts following] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_PERSON_ADD]];
			// Remove the separator from below this cell
			[cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth([cell frame]), 0, 0)];
			break;
		case 5:
			[[cell label] setText:@"Followers"];
			[[cell count] setText:[[counts followers] stringValue]];
			[[cell icon] setImage:nil];
			// Remove the separator from below this cell
			[cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth([cell frame]), 0, 0)];
			break;
		default:
			break;
	}
	
	// Return cells based on the index path (grouped)
	/*
	switch([indexPath section])
	{
		case 0:
			[[cell label] setText:@"My Votes"];
			[[cell count] setText:[[counts myVotes] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_CHECKMARK]];
			break;
		case 1:
			[[cell label] setText:@"My Posts"];
			[[cell count] setText:[[counts myPosts] stringValue]];
			[[cell icon] setImage:[UIImage imageNamed:ICON_PORTRAIT]];
			break;
		case 2:
		{
			switch([indexPath row])
			{
				case 0:
					[[cell label] setText:@"Favorite Posts"];
					[[cell count] setText:[[counts favoritePosts] stringValue]];
					[[cell icon] setImage:[UIImage imageNamed:ICON_FAVORITE_OUTLINE]];
					break;
				case 1:
					[[cell label] setText:@"Favorite Tags"];
					[[cell count] setText:[[counts favoriteTags] stringValue]];
					[[cell icon] setImage:nil];
					break;
				default:
					break;
			}
			break;
		}
		case 3:
		{
			switch([indexPath row])
			{
				case 0:
					[[cell label] setText:@"Following"];
					[[cell count] setText:[[counts following] stringValue]];
					[[cell icon] setImage:[UIImage imageNamed:ICON_PERSON_ADD]];
					break;
				case 1:
					[[cell label] setText:@"Followers"];
					[[cell count] setText:[[counts followers] stringValue]];
					[[cell icon] setImage:nil];
					break;
				default:
					break;
			}
			break;
		}
		default:
			break;
	}
	*/
}

#pragma mark - Retrieving user's counts
// Download the user's counts with a GET request
///// ****** should probably put this in UserInfo, not here ********* ///////////
- (void)getCounts
{
	// Get pointer to UserInfo object
	UserInfo *user = [UserInfo user];
	
	// If there's already a UserCounts object stored in UserInfo, then reload the TableView with the previous
	// values until the request is done
	if([user counts] != nil)
		[[self countsTableView] reloadData];
	
	// Turn on network indicator
	[[UserInfo user] setNetworkActivityIndicatorVisible:YES];
	
	// Set up request
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
	[manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
	
	// Perform the request
	[manager GET:[NSString stringWithFormat:@"%@user/count/%i", [user uri], [user userID]]
	  parameters:nil
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 
			 // Turn off network indicator
			 [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
			 
			 // Get the data out of the response
			 
			 // Looks like this; the values are ints
			 /*
			  {
				  "response": {
					  "vote_count": 0,
					  "post_count": 0,
					  "favorite_post_count": 0,
					  "favorite_hashtag_count": 0,
					  "following_count": 0,
					  "follower_count": 0
				   }
			  }
			  */
			 NSDictionary *response = [responseObject valueForKey:@"response"];
			 UserCounts *counts = [[UserCounts alloc] initWithMyVotes:[response objectForKey:@"vote_count"]
															  myPosts:[response objectForKey:@"post_count"]
														favoritePosts:[response objectForKey:@"favorite_post_count"]
														 favoriteTags:[response objectForKey:@"favorite_hashtag_count"]
															following:[response objectForKey:@"following_count"]
															followers:[response objectForKey:@"follower_count"]];
			 // Save the data
			 [user setCounts:counts];
			 
			 // Refresh the tableview
			 [[self countsTableView] reloadData];
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 
			 // Turn off network indicator
			 [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
			 
			 // Get the error message, if any
			 NSDictionary *errorResponse = [operation responseObject];
			 NSString *errorMessage = [errorResponse objectForKey:@"error"];
			 NSLog(@"*** Network error: %@", errorMessage);
			 
			 /////// ***** make a custom class out of this!! *****
			 ///////******************************************////
			 
//			 if(errorMessage != nil)
//			 {
//				 UIAlertController *alert = [UIAlertController alertControllerWithTitle:errorMessage
//																				message:@"Check your internet connection and try again."
//																		 preferredStyle:UIAlertControllerStyleAlert];
//				 [self presentViewController:alert animated:YES completion:nil];
//				 [[alert view] setTintColor:COLOR_BETTER_DARK];
//			 }
		 }];
}

- (IBAction)cycleRankIcon:(id)sender
{
	currentIcon++;
	currentIcon %= 6;
	[[[UserInfo user] rank] setRank:currentIcon];
	
	switch(currentIcon)
	{
		case 0:
			[[self rankLabel] setText:@""];
			[[self rankIcon] setImage:nil];
			break;
		case 1:
			[[self rankLabel] setText:@"Newbie"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE]];
			break;
		case 2:
			[[self rankLabel] setText:@"Mainstream"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM]];
			break;
		case 3:
			[[self rankLabel] setText:@"Trailblazer"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER]];
			break;
		case 4:
			[[self rankLabel] setText:@"Trendsetter"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER]];
			break;
		case 5:
			[[self rankLabel] setText:@"Crowned"];
			[[self rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED]];
			break;
	}
}

@end
