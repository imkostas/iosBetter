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

// Called after auto-layout is finished, so we can calculate the estimated row height (need to know the width
// of the TableView)
- (void)viewDidLayoutSubviews
{
	// 2 --> height of the hairline separator between the header of a post and the images below it
	// 98 --> height of the header UIView with 1 line of hashtags (contains hashtags, username, etc.)
	rowHeightEstimate = CGRectGetWidth([[self tableView] bounds]) + 2 + 98;
	
	/** Get a dummy cell and set it up **/
	
	_dummyCell = (FeedCell *)[[self tableView] dequeueReusableCellWithIdentifier:@"feedSingleImageCell"];
	[_dummyCell setFrame:CGRectMake(0, 0, CGRectGetWidth([[self tableView] bounds]), rowHeightEstimate)];
	[_dummyCell setHidden:YES];
	[[self view] addSubview:_dummyCell];
	
	// Set the tagsLabel to have 1 line, and non-empty usernamelabel
	[_dummyCell.headerView.tagsLabel setText:@"#"];
	[_dummyCell.headerView.usernameLabel setText:@"username"];
	
	// Run auto-layout on dummy cell
	[_dummyCell setNeedsLayout];
	[_dummyCell layoutIfNeeded];
	
	// Record the 1-line height
	tagsLabelHeightOneLine = CGRectGetHeight([_dummyCell.headerView.tagsLabel bounds]);
	
	/** Set up the dummy UILabel to mimic the properties of the one in the dummy cell **/
	
	_dummyTagsLabel = [[UILabel alloc] initWithFrame:_dummyCell.headerView.tagsLabel.frame];
	[[self dummyTagsLabel] setNumberOfLines:3];
	[[self dummyTagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self dummyTagsLabel] frame])];
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
	
	// Generate different cells based on the type of the post
	if([indexPath indexAtPosition:1] % 3 == 0)
		cell = (FeedSingleImageCell *)[tableView dequeueReusableCellWithIdentifier:@"feedSingleImageCell" forIndexPath:indexPath];
	else if([indexPath indexAtPosition:1] % 3 == 1)
		cell = (FeedLeftRightCell *)[tableView dequeueReusableCellWithIdentifier:@"feedLeftRightCell" forIndexPath:indexPath];
	else if([indexPath indexAtPosition:1] % 3 == 2)
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
	NSInteger index = [indexPath indexAtPosition:1];
	
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
	NSInteger index = [indexPath indexAtPosition:1];
	
	if(index % 3 == 0)
		[[self dummyTagsLabel] setText:@"#hello"];
	else if(index % 3 == 1)
		[[self dummyTagsLabel] setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
	else if(index % 3 == 2)
		[[self dummyTagsLabel] setText:@"#hey #hashtags #twitter #fb #meme"];
	
	int multiple = round([self dummyTagsLabel].intrinsicContentSize.height / tagsLabelHeightOneLine);
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
	if([indexPath indexAtPosition:1] % 2 == 0)
		[cell.headerView.profileImageView setImage:[UIImage imageNamed:@"donkey"]];
	else
		[cell.headerView.profileImageView setImage:[UIImage imageNamed:@"goat"]];
	
//	[[[cell headerView] profileImageView] setBackgroundColor:[UIColor greenColor]];
	
	if([indexPath indexAtPosition:1] % 3 == 0)
	{
		FeedSingleImageCell *thisCell = (FeedSingleImageCell *)cell;
		
		if(background)
			[[thisCell mainImageView] setImage:background];
		else
			[[thisCell mainImageView] setBackgroundColor:COLOR3];
		
		[thisCell.hotspot1 setPercentageValue:0.2];
		[thisCell.hotspot2 setPercentageValue:0.8];
		[thisCell.headerView.tagsLabel setText:@"#hashtag #lotsapoints"];
		[thisCell.headerView.usernameLabel setText:@"DONKEY"];
		[thisCell.headerView.numberOfVotesLabel setText:@"5000"];
	}
	else if([indexPath indexAtPosition:1] % 3 == 1)
	{
		FeedLeftRightCell *thisCell = (FeedLeftRightCell *)cell;
		[[thisCell leftImageView] setBackgroundColor:COLOR1];
		[[thisCell rightImageView] setBackgroundColor:COLOR2];
		
		[thisCell.hotspot1 setPercentageValue:0.55];
		[thisCell.hotspot2 setPercentageValue:0.45];
		[thisCell.headerView.tagsLabel setText:@"#charger #donkey #firstdate #romantic #hair #workplace #beauty #classic #splurge #partytime"];
		[thisCell.headerView.usernameLabel setText:@"GOAT"];
		[thisCell.headerView.numberOfVotesLabel setText:@"6"];
	}
	else if([indexPath indexAtPosition:1] % 3 == 2)
	{
		FeedTopBottomCell *thisCell = (FeedTopBottomCell *)cell;
		[[thisCell topImageView] setBackgroundColor:COLOR1];
		[[thisCell bottomImageView] setBackgroundColor:COLOR2];
		
		[thisCell.hotspot1 setPercentageValue:0.01];
		[thisCell.hotspot2 setPercentageValue:0.99];
		[thisCell.headerView.tagsLabel setText:@"#hey #hashtags #twitter #fb #meme"];
		[thisCell.headerView.usernameLabel setText:@"UUUUUSER"];
		[thisCell.headerView.numberOfVotesLabel setText:@"9999"];
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
											  
											  NSLog(@"Response: %@", response);
											  
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
