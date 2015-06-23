//
//  Leaderboard.m
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Leaderboard.h"

#define LIMIT 10

@interface Leaderboard ()
{
	// Keep a reference to the user object (don't call -user for every table cell)
	UserInfo *user;
}

// Get the leaderboard data
- (void)getLeaderboardData;

@end

@implementation Leaderboard

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set up this object and the TableView's color
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	[[self tableView] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
	
	// Set up TableView
	[[self tableView] setDataSource:self];
	[[self tableView] setDelegate:self];
	
	// Get UserInfo
	user = [UserInfo user];
}

- (void)viewDidAppear:(BOOL)animated
{
	// Start download process
	[self getLeaderboardData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getting data
- (void)getLeaderboardData
{
	// If there's already leaderboard data in UserInfo, use that for now, until the download finishes
	if([user leaderboardData] != nil)
		[[self tableView] reloadData]; /// Necessary?
	
	// Turn on network indicator
	[[UserInfo user] setNetworkActivityIndicatorVisible:YES];
	
	// Set up request
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
	[manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
	
	// Perform request
	[manager GET:[NSString stringWithFormat:@"%@/rank/%i", [user uri], LIMIT]
	  parameters:nil
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 
			 // Turn off network indicator
			 [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
			 
			 // Retrieve data
			 NSDictionary *response = [responseObject objectForKey:@"response"];
			 LeaderboardData *leaderData = [[LeaderboardData alloc] initWithDailyData:[response valueForKey:@"daily_leaderboard"]
																		   weeklyData:[response valueForKey:@"weekly_leaderboard"]
																		  allTimeData:[response valueForKey:@"all_time_leaderboard"]];
			 
			 // Save data in UserInfo
			 [user setLeaderboardData:leaderData];
			 
			 // Tell tableview to reload data
			 [[self tableView] reloadData];
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 
			 // Turn off network indicator
			 [[UserInfo user] setNetworkActivityIndicatorVisible:NO];
			 
			 // Get error message
			 NSDictionary *errorResponse = [operation responseObject];
			 NSString *errorMessage = [errorResponse objectForKey:@"error"];
			 NSLog(@"***!!! Network error: %@", errorMessage);
		 }];
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

#pragma mark - Responding to UI
- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
	// Reload the TableView
	[[self tableView] reloadData];
}

#pragma mark - UITableView datasource methods
// Uses a custom xib for the leaderboard cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Dequeue a cell, or register the nib file if dequeueing doesn't work
	LeaderboardTableViewCell *cell = (LeaderboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_LEADERBOARD_TABLECELL];
	
	if(cell == nil)
	{
		// Register the xib file to use for this table view cell
		[tableView registerNib:[UINib nibWithNibName:@"LeaderboardTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:REUSE_ID_LEADERBOARD_TABLECELL];
		
		// Dequeue a cell
		cell = (LeaderboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_LEADERBOARD_TABLECELL];
	}
	
	return cell;
}

// Return the result of -count on the corresponding NSArray (daily/weekly/alltime) inside the LeaderboardData object
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// If the data isn't ready yet, don't show anything
	if([user leaderboardData] == nil)
		return 0;
	
	// Otherwise, return the number of items per leaderboard type (Daily, etc.)
	switch([[self segmentedControl] selectedSegmentIndex])
	{
		case 0: // Daily
			return [[[user leaderboardData] daily] count];
		case 1: // Weekly
			return [[[user leaderboardData] weekly] count];
		case 2: // All time
			return [[[user leaderboardData] allTime] count];
		default:
			return 0;
	}
}

#pragma mark - UITableView delegate methods
// Customize each cell depending on their index (matches the index of the leaderboard arrays)
// Each cell has these visual properties: index, profile image, username, rank icon, and points value
- (void)tableView:(UITableView *)tableView willDisplayCell:(LeaderboardTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return the correct data depending on the selected segment (Daily, etc.)
	NSArray *targetArray = nil;
	switch([[self segmentedControl] selectedSegmentIndex])
	{
		case 0: targetArray = [[user leaderboardData] daily]; break;
		case 1: targetArray = [[user leaderboardData] weekly]; break;
		case 2: targetArray = [[user leaderboardData] allTime]; break;
		default: targetArray = nil;
	}
	
	// If the data is nil for some reason, then stop here
	if(targetArray == nil)
		return;
	
	// Otherwise, set up the cell for the corresponding index
	NSDictionary *thisUser = [targetArray objectAtIndex:[indexPath indexAtPosition:1]];
	
	// The dictionary keys are: "rank", "total_points", "user_id", and "username".
	// The values are all strings.
	
	// Set up index (1, 2, 3, ....)
	[[cell indexLabel] setText:[NSString stringWithFormat:@"%i", ([indexPath indexAtPosition:1] + 1)]];
	
	// Set up profile picture (TO-DO) layer properties first
	[[[cell profileImage] layer] setCornerRadius:(CGRectGetWidth([[cell profileImage] frame]) / 2)];
	[[[cell profileImage] layer] setMasksToBounds:YES];
	[[[cell profileImage] layer] setShouldRasterize:YES];
	// Then apply the image
	[[cell profileImage] setImage:[UIImage imageNamed:@"donkey"]];
	
	// Set up username
	[[cell usernameLabel] setText:[thisUser valueForKey:@"username"]];
	
	// Set up rank icon
	switch([[thisUser valueForKey:@"rank"] intValue])
	{
		case RANK_TRENDSETTER:
			[[cell rankIcon] setImage:nil];
			break;
		case RANK_NOOB:
			[[cell rankIcon] setImage:[UIImage imageNamed:ICON_RANK_NEWBIE]];
			break;
		case RANK_MAINSTREAM:
			[[cell rankIcon] setImage:[UIImage imageNamed:ICON_RANK_MAINSTREAM]];
			break;
		case RANK_TRAILBLAZER:
			[[cell rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRAILBLAZER]];
			break;
		case RANK_NORANK:
			[[cell rankIcon] setImage:[UIImage imageNamed:ICON_RANK_TRENDSETTER]];
			break;
		case RANK_CROWNED:
			[[cell rankIcon] setImage:[UIImage imageNamed:ICON_RANK_CROWNED]];
			break;
	}
	
	// Set up points
	[[cell pointsLabel] setText:[thisUser valueForKey:@"total_points"]];
}

@end
	 
/* Data from API looks like this:
 {
 "response": {
 "all_time_leaderboard": [
	 {
	 "user_id": "1",
	 "username": "ASTAPLEY",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "2",
	 "username": "PETERG",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "3",
	 "username": "PETERLG",
	 "rank": "0",
	 "total_points": "0"
	 }
 ],
 "weekly_leaderboard": [
	 {
	 "user_id": "1",
	 "username": "ASTAPLEY",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "2",
	 "username": "PETERG",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "3",
	 "username": "PETERLG",
	 "rank": "0",
	 "total_points": "0"
	 }
 ],
 "daily_leaderboard": [
	 {
	 "user_id": "1",
	 "username": "ASTAPLEY",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "2",
	 "username": "PETERG",
	 "rank": "0",
	 "total_points": "0"
	 },
	 {
	 "user_id": "3",
	 "username": "PETERLG",
	 "rank": "0",
	 "total_points": "0"
	 }
 ]
 }
 }
 */
