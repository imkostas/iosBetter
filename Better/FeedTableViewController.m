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
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedSingleImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedSingleImageCell"];
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedLeftRightCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedLeftRightCell"];
	[[self tableView] registerNib:[UINib nibWithNibName:@"FeedTopBottomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"feedTopBottomCell"];
}

// Called before auto-layout has happened--here, we create the dummy cell and add it to [self view], but don't
// run auto layout on it just yet
- (void)viewWillLayoutSubviews
{
	/** Initialize the dummy cell and add it to [self view], but don't tell it to run auto-layout just yet **/
	 
	_dummyCell = (FeedCell *)[[self tableView] dequeueReusableCellWithIdentifier:@"feedSingleImageCell"];
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
	[[self dummyTagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self dummyTagsLabel] frame])];
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
	UITableViewCell *cell = nil;
	NSInteger index = [indexPath row];
	
	// Generate different cells based on the type of the post
	if(index % 3 == 0)
		cell = (FeedSingleImageCell *)[tableView dequeueReusableCellWithIdentifier:@"feedSingleImageCell" forIndexPath:indexPath];
	else if(index % 3 == 1)
		cell = (FeedLeftRightCell *)[tableView dequeueReusableCellWithIdentifier:@"feedLeftRightCell" forIndexPath:indexPath];
	else if(index % 3 == 2)
		cell = (FeedTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:@"feedTopBottomCell" forIndexPath:indexPath];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"getting number of rows");
	return numRows;
}

#pragma mark - UITableView delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat adjustmentHeight = 0;
	NSInteger index = [indexPath row];
	
	if(index % 3 == 0)
		[[self dummyTagsLabel] setText:@"#hashtag #lotsapoints"];
	else if(index % 3 == 1)
		[[self dummyTagsLabel] setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
	else if(index % 3 == 2)
		[[self dummyTagsLabel] setText:@"#hey #hashtags #twitter #fb #meme"];
	
	int multiple = roundf([self dummyTagsLabel].intrinsicContentSize.height / tagsLabelHeightOneLine);
	if(multiple == 3) // 3 lines of text
		adjustmentHeight = tagsLabelHeightOneLine; // Add one line of vertical space
	
	return CGRectGetWidth([[self tableView] frame]) + 2 + 98 + adjustmentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	return rowHeightEstimate;
	
	CGFloat adjustmentHeight = 0;
	NSInteger index = [indexPath row];
	
	if(index % 3 == 0)
		[[self dummyTagsLabel] setText:@"#hello"];
	else if(index % 3 == 1)
		[[self dummyTagsLabel] setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
	else if(index % 3 == 2)
		[[self dummyTagsLabel] setText:@"#hey #hashtags #twitter #fb #meme"];
	
	int multiple = roundf([self dummyTagsLabel].intrinsicContentSize.height / tagsLabelHeightOneLine);
	if(multiple == 3) // 3 lines of text
		adjustmentHeight = tagsLabelHeightOneLine; // Add one line of vertical space
	
	return CGRectGetWidth([[self tableView] frame]) + 2 + 98 + adjustmentHeight;
}

#define COLOR1 [UIColor colorWithRed:81/255. green:207/255. blue:224/255. alpha:1]
#define COLOR2 [UIColor colorWithRed:196/255. green:81/255. blue:225/255. alpha:1]
#define COLOR3 [UIColor colorWithRed:127/255. green:209/255. blue:113/255. alpha:1]

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Set prof pic
	if([indexPath row] % 2 == 0)
//		[cell.headerView.profileImageView setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_FEMALE]];
		[cell.profileImageView setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_FEMALE]];
	else
//		[cell.headerView.profileImageView setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_MALE]];
		[cell.profileImageView setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_MALE]];
	
//	[[[cell headerView] profileImageView] setBackgroundColor:[UIColor greenColor]];
	
	if([indexPath row] % 3 == 0)
	{
		FeedSingleImageCell *thisCell = (FeedSingleImageCell *)cell;
		
		if(background)
			[[thisCell mainImageView] setImage:background];
		else
			[[thisCell mainImageView] setBackgroundColor:COLOR3];
		
		[thisCell.hotspot1 setPercentageValue:0.2];
		[thisCell.hotspot2 setPercentageValue:0.8];
//		[thisCell.headerView.tagsLabel setText:@"#hashtag #lotsapoints"];
//		[thisCell.headerView.usernameLabel setText:@"DONKEY"];
//		[thisCell.headerView.numberOfVotesLabel setText:@"5000"];
		[thisCell.tagsLabel setText:@"#hashtag #lotsapoints"];
		[thisCell.usernameLabel setText:@"DONKEY"];
		[thisCell.numberOfVotesLabel setText:@"5000"];
	}
	else if([indexPath row] % 3 == 1)
	{
		FeedLeftRightCell *thisCell = (FeedLeftRightCell *)cell;
		
		if(image2)
			[[thisCell leftImageView] setImage:image2];
		else
			[[thisCell leftImageView] setBackgroundColor:COLOR1];
		
		if(image3)
			[[thisCell rightImageView] setImage:image3];
		else
			[[thisCell rightImageView] setBackgroundColor:COLOR2];
		
		[thisCell.hotspot1 setPercentageValue:0.55];
		[thisCell.hotspot2 setPercentageValue:0.45];
//		[thisCell.headerView.tagsLabel setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
//		[thisCell.headerView.usernameLabel setText:@"GOAT"];
//		[thisCell.headerView.numberOfVotesLabel setText:@"6"];
		[thisCell.tagsLabel setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
		[thisCell.usernameLabel setText:@"GOAT"];
		[thisCell.numberOfVotesLabel setText:@"6"];
	}
	else if([indexPath row] % 3 == 2)
	{
		FeedTopBottomCell *thisCell = (FeedTopBottomCell *)cell;
		
		if(image4)
			[[thisCell topImageView] setImage:image4];
		else
			[[thisCell topImageView] setBackgroundColor:COLOR1];
		
		if(image5)
			[[thisCell bottomImageView] setImage:image5];
		else
			[[thisCell bottomImageView] setBackgroundColor:COLOR2];
		
		[thisCell.hotspot1 setPercentageValue:0.01];
		[thisCell.hotspot2 setPercentageValue:0.99];
//		[thisCell.headerView.tagsLabel setText:@"#hey #hashtags #twitter #fb #meme"];
//		[thisCell.headerView.usernameLabel setText:@"UUUUUSER"];
//		[thisCell.headerView.numberOfVotesLabel setText:@"9999"];
		[thisCell.tagsLabel setText:@"#hey #hashtags #twitter #fb #meme"];
		[thisCell.usernameLabel setText:@"UUUUUSER"];
		[thisCell.numberOfVotesLabel setText:@"9999"];
	}
}

- (IBAction)buttonPressed:(id)sender
{
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
												  dispatch_async(dispatch_get_main_queue(), ^{
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
												  dispatch_async(dispatch_get_main_queue(), ^{
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
												  dispatch_async(dispatch_get_main_queue(), ^{
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
												   dispatch_async(dispatch_get_main_queue(), ^{
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
												   dispatch_async(dispatch_get_main_queue(), ^{
													   [[self tableView] reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
												   });
											   }
										   }];
	[urlTask5 resume];
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
