//
//  MyInformationTableView.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyInformationTableViewController.h"

@interface MyInformationTableViewController ()

// Reference to the UserInfo shared object
@property (weak, nonatomic) UserInfo *user;

// Called when the refreshControl property of this object sends the UIControlEventValueChanged event
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;

// Called to download the user's count values from the API
- (void)getCounts;

/** Saves the default uitableview edge insets */
@property (nonatomic) UIEdgeInsets defaultTableViewSeparatorInsets;

@end

@implementation MyInformationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up this view's colors
    [[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
    
    // Get pointer to UserInfo
    _user = [UserInfo user];
    
    // Register the correct type of UITableViewCell for the UITableView
    [[self tableView] registerNib:[UINib nibWithNibName:@"MyInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:REUSE_ID_MYINFORMATION_TABLECELL];
    
    // Make all separators invisible (some are set to visible later) and remember the default value
    _defaultTableViewSeparatorInsets = [[self tableView] separatorInset];
    [[self tableView] setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth([[self view] bounds]), 0, 0)];
    
    // Set up a UIRefreshControl
    [[self refreshControl] setTintColor:COLOR_BETTER_DARK];
    [[self refreshControl] addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Call super
    [super viewWillAppear:animated];
    
    // Load the counts data
    [self getCounts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Responding to UIRefreshControl
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    // Call [self getCounts] if the refresh control is refreshing
    if([refreshControl isRefreshing])
        [self getCounts];
}

#pragma mark - Table view data source
// How many sections in the TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // One section only
    return 1;
}

// How many rows in a section (there is only one section)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 6;
    else
        return 0;
}

// Return a reusable cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue an instance of MyInfoTableViewCell
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_MYINFORMATION_TABLECELL forIndexPath:indexPath];
    
    return cell;
}

// Return a height for each MyInfoTableViewCell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Common height for all cells in this UITableView
    return 55;
}

// Configure the cell right before it appears
- (void)tableView:(UITableView *)tableView willDisplayCell:(MyInfoTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the UserCounts object
    UserCounts *counts = [[self user] counts];
    
    // Return cells based on the index path (non-grouped)
    switch([indexPath row])
    {
        case 0:
            [[cell label] setText:@"My Votes"];
            [[cell count] setText:[[counts myVotes] stringValue]];
            [[cell icon] setImage:[UIImage imageNamed:ICON_CHECKMARK]];
            // Reveal the separator
            [cell setSeparatorInset:[self defaultTableViewSeparatorInsets]];
            break;
        case 1:
            [[cell label] setText:@"My Posts"];
            [[cell count] setText:[[counts myPosts] stringValue]];
            [[cell icon] setImage:[UIImage imageNamed:ICON_PORTRAIT]];
            // Reveal the separator
            [cell setSeparatorInset:[self defaultTableViewSeparatorInsets]];
            break;
        case 2:
            [[cell label] setText:@"Favorite Posts"];
            [[cell count] setText:[[counts favoritePosts] stringValue]];
            [[cell icon] setImage:[UIImage imageNamed:ICON_FAVORITE_OUTLINE]];
            break;
        case 3:
            [[cell label] setText:@"Favorite Tags"];
            [[cell count] setText:[[counts favoriteTags] stringValue]];
            [[cell icon] setImage:nil];
            // Reveal the separator
            [cell setSeparatorInset:[self defaultTableViewSeparatorInsets]];
            break;
        case 4:
            [[cell label] setText:@"Following"];
            [[cell count] setText:[[counts following] stringValue]];
            [[cell icon] setImage:[UIImage imageNamed:ICON_PERSON_ADD]];
            break;
        case 5:
            [[cell label] setText:@"Followers"];
            [[cell count] setText:[[counts followers] stringValue]];
            [[cell icon] setImage:nil];
            break;
        default:
            break;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark - Networking
// Downloads the user's counts
- (void)getCounts
{
    // If there's already a UserCounts object stored in UserInfo, then reload the TableView with the previous
    // values until the request is done
    if([[self user] counts] != nil)
        [[self tableView] reloadData];
    
    // Set up request
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Perform the request
    [manager GET:[NSString stringWithFormat:@"%@user/count/%i", [[self user] uri], [[self user] userID]]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             // Turn off the refreshing control
             [[self refreshControl] endRefreshing];
             
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
             [[self user] setCounts:counts];
             
             // Refresh the tableview
             [[self tableView] reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             // Turn off the refreshing control
             [[self refreshControl] endRefreshing];
             
             // Get the error message, if any
             NSDictionary *errorResponse = [operation responseObject];
             NSString *errorMessage = [errorResponse objectForKey:@"error"];
             NSLog(@"*** Network error: %@", errorMessage);
 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
