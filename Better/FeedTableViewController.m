//
//  FeedTableViewController.m
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "FeedTableViewController.h"

@interface FeedTableViewController ()
{
	NSInteger numRows;
	
	/**
	 This is the height of a cell that has not been stretched to accomodate extra lines of hashtags
	 **/
	CGFloat rowHeightEstimate;
	
	/**
	 This is the height of a hashtags label that has one line of text
	 **/
	CGFloat tagsLabelHeightOneLine;
	
	UIImage *background;
	UIImage *image2;
	UIImage *image3;
	UIImage *image4;
	UIImage *image5;
}

@property (strong, nonatomic) FeedCell *dummyCell;
@property (strong, nonatomic) UILabel *dummyTagsLabel;

@end

@implementation FeedTableViewController

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Set up tableview
	[[self tableView] setDataSource:self];
	[[self tableView] setDelegate:self];
	[[self tableView] setBackgroundColor:COLOR_GRAY];
	
	numRows = 10;
	tagsLabelHeightOneLine = 0;
	
	// Register nibs for each type of cell (single, double image horizontal, and double image vertical)
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedCellSingleImage" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedCellSingleImage"];
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedCellLeftRight" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedCellLeftRight"];
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedCellTopBottom" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedCellTopBottom"];
    
    // Create a new FeedDataController to provide data from the API
    _dataController = [[FeedDataController alloc] init];
    [_dataController setDelegate:self];
}

// Called before auto-layout has happened--here, we create the dummy cell and add it to [self view], but don't
// run auto layout on it just yet
- (void)viewWillLayoutSubviews
{
    // Call super
    [super viewWillLayoutSubviews];
    
	/** Initialize the dummy cell and add it to [self view], but don't tell it to run auto-layout just yet **/
	 
	_dummyCell = (FeedCell *)[[self tableView] dequeueReusableCellWithIdentifier:@"feedCellSingleImage"];
	[[self dummyCell] setHidden:YES];
	[[self view] addSubview:[self dummyCell]];
	
	// Set the tagsLabel to have 1 line, and non-empty usernamelabel
//	[[self dummyCell].headerView.tagsLabel setText:@"#"];
//	[[self dummyCell].headerView.usernameLabel setText:@"username"];
	[[self dummyCell].tagsLabel setText:@"#"];
	[[self dummyCell].usernameLabel setText:@"username"];
}

// Called after auto-layout is finished(?), so we can calculate the estimated row height (need to know the width
// of the TableView)
- (void)viewDidLayoutSubviews
{
    // Call super
    [super viewDidLayoutSubviews];
    
	// 2 --> height of the hairline separator between the header of a post and the images below it
	// 98 --> height of the header UIView with 1 line of hashtags (contains hashtags, username, etc.)
	rowHeightEstimate = CGRectGetWidth([[self tableView] bounds]) + 2 + 98;
	
	// Set frame of dummy cell
	[[self dummyCell] setFrame:CGRectMake(0, 0, CGRectGetWidth([[self tableView] bounds]), rowHeightEstimate)];
	
	// Run auto-layout on dummy cell initialized in -viewWillLayoutSubviews
	[[self dummyCell] setNeedsLayout];
	[[self dummyCell] layoutIfNeeded];
	
	// Record the 1-line height
//	tagsLabelHeightOneLine = CGRectGetHeight([_dummyCell.headerView.tagsLabel bounds]);
	tagsLabelHeightOneLine = CGRectGetHeight([_dummyCell.tagsLabel bounds]);
	
	/** Set up the dummy UILabel to mimic the properties of the one in the dummy cell **/
//	_dummyTagsLabel = [[UILabel alloc] initWithFrame:_dummyCell.headerView.tagsLabel.frame];
	_dummyTagsLabel = [[UILabel alloc] initWithFrame:_dummyCell.tagsLabel.frame];
	[[self dummyTagsLabel] setNumberOfLines:3];
    [[self dummyTagsLabel] setFont:[[_dummyCell tagsLabel] font]];
	[[self dummyTagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self dummyTagsLabel] frame])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load some post data
    [[self dataController] loadPostsIncremental];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// Get rid of dummy cell
	[[self dummyCell] removeFromSuperview];
    _dummyCell = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the post corresponding to the given indexPath
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    
    // Generate different cells based on the type of the post
    UITableViewCell *cell = nil;
    switch([thisPost layoutType])
    {
        case LAYOUTSTATE_A_ONLY: // One image only
            cell = (FeedCellSingleImage *)[tableView dequeueReusableCellWithIdentifier:@"feedCellSingleImage" forIndexPath:indexPath];
            break;
    
        case LAYOUTSTATE_LEFT_RIGHT: // Two images, side by side
            cell = (FeedCellLeftRight *)[tableView dequeueReusableCellWithIdentifier:@"feedCellLeftRight" forIndexPath:indexPath];
            break;
    
        case LAYOUTSTATE_TOP_BOTTOM: // Two images, top and bottom
            cell = (FeedCellTopBottom *)[tableView dequeueReusableCellWithIdentifier:@"feedCellTopBottom" forIndexPath:indexPath];
            break;
    }
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"getting number of rows");
//	return numRows;
    
    return [[self dataController] numberOfPosts];
}

#pragma mark - UITableView delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat adjustmentHeight = 0;
    
    // Get the PostObject for this indexPath and set the text of the dummy label to the hashtags text
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    [[self dummyTagsLabel] setText:[[thisPost tagsAttributedString] string]];
	
	int multiple = roundf([self dummyTagsLabel].intrinsicContentSize.height / tagsLabelHeightOneLine);
	if(multiple == 3) // 3 lines of text
		adjustmentHeight = tagsLabelHeightOneLine; // Add one line of vertical space
	
	return CGRectGetWidth([[self tableView] frame]) + 2 + 98 + adjustmentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetWidth([[self tableView] frame]) + 2 + 98;
}

#define COLOR1 [UIColor colorWithRed:81/255. green:207/255. blue:224/255. alpha:1]
#define COLOR2 [UIColor colorWithRed:196/255. green:81/255. blue:225/255. alpha:1]
#define COLOR3 [UIColor colorWithRed:127/255. green:209/255. blue:113/255. alpha:1]

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the post for this indexPath
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    
    // Populate the cell's UI elements
    [[cell tagsLabel] setAttributedText:[thisPost tagsAttributedString]];
//    [[cell tagsLabel] setText:[[thisPost tagsAttributedString] string]];
    [[cell usernameLabel] setText:[thisPost username]];
    [[cell numberOfVotesLabel] setText:[NSString stringWithFormat:@"%i", [thisPost numberOfVotes]]];
    [[cell profileImageView] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_FEMALE]];
    
    switch([thisPost layoutType])
    {
        case LAYOUTSTATE_A_ONLY:
        {
            FeedCellSingleImage *thisCell = (FeedCellSingleImage *)cell;
        }
    }
}

#pragma mark - FeedDataControllerDelegate methods
// Called when the FeedDataController has loaded some posts
- (void)feedDataController:(FeedDataController *)feedDataController didLoadPostsAtIndexPaths:(NSArray *)indexPaths
{
    // Insert only the given index paths
    [[self tableView] insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}

// Called when the FeedDataController is done reloading all posts
- (void)feedDataControllerDidReloadAllPosts:(FeedDataController *)feedDataController
{
    // Reload everything
    [[self tableView] reloadData];
}

//- (IBAction)buttonPressed:(id)sender
//{
    /*
	NSURLSession *urlSession = [NSURLSession sharedSession];
	NSURLSessionTask *urlTask = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://dummyimage.com/600x600/333/0cc.png"]
										  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											  
											  background = [UIImage imageWithData:data];
											  if(!background)
												  NSLog(@"Downloaded image is nil");
											  
											  if(background)
											  {
												  NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
												  
												  // Update the tableview on the main thread (UI runs on main thread)
												  dispatch_sync(dispatch_get_main_queue(), ^{
													  [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												  });
											  }
										  }];
	[urlTask resume];
	
	NSURLSessionTask *urlTask2 = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://dummyimage.com/300x600/f04/333.png"]
										  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											  
											  image2 = [UIImage imageWithData:data];
											  if(!image2)
												  NSLog(@"Downloaded image is nil");
											  
											  if(image2)
											  {
												  NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
												  
												  // Update the tableview on the main thread (UI runs on main thread)
												  dispatch_sync(dispatch_get_main_queue(), ^{
													  [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												  });
											  }
										  }];
	[urlTask2 resume];
	
	NSURLSessionTask *urlTask3 = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://dummyimage.com/300x600/eee/c0c.png"]
										  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											  
											  image3 = [UIImage imageWithData:data];
											  if(!image3)
												  NSLog(@"Downloaded image is nil");
											  
											  if(image3)
											  {
												  NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
												  
												  // Update the tableview on the main thread (UI runs on main thread)
												  dispatch_sync(dispatch_get_main_queue(), ^{
													  [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												  });
											  }
										  }];
	[urlTask3 resume];
	
	NSURLSessionTask *urlTask4 = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://dummyimage.com/600x300/bbb/f03.png"]
										   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											   
											   image4 = [UIImage imageWithData:data];
											   if(!image4)
												   NSLog(@"Downloaded image is nil");
											   
											   if(image4)
											   {
												   NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]];
												   
												   // Update the tableview on the main thread (UI runs on main thread)
												   dispatch_sync(dispatch_get_main_queue(), ^{
													   [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												   });
											   }
										   }];
	[urlTask4 resume];
	
	NSURLSessionTask *urlTask5 = [urlSession dataTaskWithURL:[NSURL URLWithString:@"http://dummyimage.com/600x300/123/456.png"]
										   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
											   
											   image5 = [UIImage imageWithData:data];
											   if(!image5)
												   NSLog(@"Downloaded image is nil");
											   
											   if(image5)
											   {
												   NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]];
												   
												   // Update the tableview on the main thread (UI runs on main thread)
												   dispatch_sync(dispatch_get_main_queue(), ^{
													   [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												   });
											   }
										   }];
	[urlTask5 resume];
     */
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
