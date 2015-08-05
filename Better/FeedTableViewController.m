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
    
    /** A flag to ensure that the FeedDataController only loads posts by itself once, the first time -viewWillAppear:
     is called */
    BOOL hasLoadedInitialPosts;
    
    /** A flag to ensure that this FeedTableViewController only sets up the dummy cell and dummy label once,
     since -viewWillLayoutSubviews and -viewDidLayoutSubviews seem to be called every time the UITableView
     is scrolled (this behavior only started when the UITableView was moved to within UITableViewController)
     (8/3/15) */
    BOOL hasInitializedDummyObjects;
	
	UIImage *background;
	UIImage *image2;
	UIImage *image3;
	UIImage *image4;
	UIImage *image5;
}

// Dummy objects for sizing real cells
@property (strong, nonatomic) FeedCell *dummyCell;
@property (strong, nonatomic) UILabel *dummyTagsLabel;

// Called when this class's UIRefreshControl sends the UIControlEventValueChanged event
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;

@end

@implementation FeedTableViewController

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Set up UITableView
	[[self tableView] setBackgroundColor:COLOR_GRAY];
    [[self tableView] setShowsHorizontalScrollIndicator:NO];
    [[self tableView] setShowsVerticalScrollIndicator:NO];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone]; // No horizontal separators
    [[self tableView] setAllowsSelection:NO];
    [[self tableView] setAllowsSelectionDuringEditing:NO];
    [[self tableView] setAllowsMultipleSelection:NO];
    [[self tableView] setAllowsMultipleSelectionDuringEditing:NO];
    
    // Set up this UITableViewController and register to receive the UIRefreshControl's value changed event
    [[self refreshControl] addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [[self refreshControl] setTintColor:COLOR_BETTER_DARK];
	
    // Initialize
	tagsLabelHeightOneLine = 0;
    hasLoadedInitialPosts = FALSE;
    hasInitializedDummyObjects = FALSE;
	
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
    if(!hasInitializedDummyObjects)
    {
        _dummyCell = (FeedCell *)[[self tableView] dequeueReusableCellWithIdentifier:@"feedCellSingleImage"];
        [[self dummyCell] setHidden:YES];
        [[self view] addSubview:[self dummyCell]];
        
        // Set the tagsLabel to have 1 line, and non-empty usernamelabel
        [[self dummyCell].tagsLabel setText:@"#"];
        [[self dummyCell].usernameLabel setText:@"username"];
    }
}

// Called after auto-layout is finished(?), so we can calculate the estimated row height (need to know the width
// of the TableView)
- (void)viewDidLayoutSubviews
{
    // Call super
    [super viewDidLayoutSubviews];
    
    // Only run this setup if we haven't done it already once
    if(!hasInitializedDummyObjects)
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
        tagsLabelHeightOneLine = CGRectGetHeight([_dummyCell.tagsLabel bounds]);
        
        /** Set up the dummy UILabel to mimic the properties of the one in the dummy cell **/
        _dummyTagsLabel = [[UILabel alloc] initWithFrame:_dummyCell.tagsLabel.frame];
        [[self dummyTagsLabel] setNumberOfLines:3];
        [[self dummyTagsLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_FEEDCELL_HASHTAG_LABEL]];
        [[self dummyTagsLabel] setPreferredMaxLayoutWidth:CGRectGetWidth([[self dummyTagsLabel] frame])];
        
        // Only run once
        hasInitializedDummyObjects = TRUE;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load some post data automatically (if it hasn't been done once already)
    if(!hasLoadedInitialPosts)
    {
        [[self dataController] loadPostsIncremental];
        hasLoadedInitialPosts = TRUE; // You only load once (YOLO)
    }
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
    FeedCell *cell = nil;
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
    
    // Set the cell's delegate to this object, to be notified of hotspot and 3-dot button taps
    [cell setDelegate:self];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"getting number of rows");
    
    return [[self dataController] numberOfPosts];
}

#pragma mark - UITableView delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat adjustmentHeight = 0;
    
    // Get the PostObject for this indexPath and set the text of the dummy label to the hashtags text
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    [[self dummyTagsLabel] setText:[[thisPost tagsAttributedString] string]];
	
    float intrinsicHeight = [self dummyTagsLabel].intrinsicContentSize.height;
	int multiple = roundf(intrinsicHeight / tagsLabelHeightOneLine);
	if(multiple == 3) // 3 lines of text
		adjustmentHeight = tagsLabelHeightOneLine; // Add one line of vertical space
	
	return CGRectGetWidth([[self tableView] frame]) + 2 + 98 + adjustmentHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat adjustmentHeight = 0;
    
    // Get the PostObject for this indexPath and set the text of the dummy label to the hashtags text
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    [[self dummyTagsLabel] setText:[[thisPost tagsAttributedString] string]];
    
    float intrinsicHeight = [self dummyTagsLabel].intrinsicContentSize.height;
    int multiple = roundf(intrinsicHeight / tagsLabelHeightOneLine);
    if(multiple == 3) // 3 lines of text
        adjustmentHeight = tagsLabelHeightOneLine; // Add one line of vertical space
    
    return CGRectGetWidth([[self tableView] frame]) + 2 + 98 + adjustmentHeight;
}

#define COLOR1 [UIColor colorWithRed:50/255. green:50/255. blue:50/255. alpha:1]
#define COLOR2 [UIColor colorWithRed:196/255. green:81/255. blue:225/255. alpha:1]
#define COLOR3 [UIColor colorWithRed:54/255. green:202/255. blue:37/255. alpha:1]

- (void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the post for this indexPath
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    
    // Tell the cell which PostObject it is representing right now
    [cell setPostObject:thisPost];
    
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
            [[thisCell mainImageView] setBackgroundColor:COLOR1];
//            [[thisCell mainImageView] setImage:[UIImage imageNamed:@"goat"]];
            [[thisCell hotspotA] setPercentageValue:0.9];
            [[thisCell hotspotB] setPercentageValue:0.1];
            break;
        }
        case LAYOUTSTATE_LEFT_RIGHT:
        {
            FeedCellLeftRight *thisCell = (FeedCellLeftRight *)cell;
            [[thisCell leftImageView] setBackgroundColor:COLOR1];
            [[thisCell rightImageView] setBackgroundColor:COLOR3];
            [[thisCell hotspotA] setPercentageValue:0.51];
            [[thisCell hotspotB] setPercentageValue:0.49];
            break;
        }
        case LAYOUTSTATE_TOP_BOTTOM:
        {
            FeedCellTopBottom *thisCell = (FeedCellTopBottom *)cell;
            [[thisCell topImageView] setBackgroundColor:COLOR3];
            [[thisCell bottomImageView] setBackgroundColor:COLOR1];
            [[thisCell hotspotA] setPercentageValue:0.6];
            [[thisCell hotspotB] setPercentageValue:0.4];
            break;
        }
    }
    
    // If the second-to-last cell of the TableView is going to be displayed, load some more data
    if([indexPath row] == [[self dataController] numberOfPosts] - 2)
        [[self dataController] loadPostsIncremental];
}

#pragma mark - FeedDataControllerDelegate methods
// Called when the FeedDataController has loaded some posts
- (void)feedDataController:(FeedDataController *)feedDataController didLoadPostsAtIndexPaths:(NSArray *)loadedPaths removePostsAtIndexPaths:(NSArray *)removedPaths
{
    // Insert only the given index paths
    [[self tableView] beginUpdates];
    [[self tableView] deleteRowsAtIndexPaths:removedPaths withRowAnimation:UITableViewRowAnimationRight];
    [[self tableView] insertRowsAtIndexPaths:loadedPaths withRowAnimation:UITableViewRowAnimationLeft];
    [[self tableView] endUpdates];
    
    // Stop the UIRefreshControl
    if([[self refreshControl] isRefreshing])
        [[self refreshControl] endRefreshing];
}

// Called when the FeedDataController is done reloading all posts
- (void)feedDataControllerDidReloadAllPosts:(FeedDataController *)feedDataController
{
//    // Reload everything
//    [[self tableView] reloadData];
//    
//    // Stop the UIRefreshControl
//    [[self refreshControl] endRefreshing];
}

#pragma mark - FeedCellDelegate methods
// Called when a cell's 3-dot button is pressed
- (void)threeDotButtonWasTappedForFeedCell:(FeedCell *)cell
{
    // Get this post's hashtags (-indexPathForCell returns nil if the cell is not visible, but the cell
    // has to be visible for the 3-dot button to be tapped, so it works in this case)
    PostObject *thisPost = [[self dataController] postAtIndexPath:[[self tableView] indexPathForCell:cell]];
    
    // Create a ThreeDotDataObject to give to the ThreeDotViewController
    BOOL postHasVotes = ([thisPost numberOfVotes] > 0) ? TRUE : FALSE;
    BOOL isOwnPost = ([thisPost userID] == [[UserInfo user] userID]) ? TRUE : FALSE;

    ThreeDotDataObject *data = [[ThreeDotDataObject alloc] init];
    [data setOwnPost:isOwnPost];
    [data setHasVotes:postHasVotes];
    [data setTags:[thisPost tags]];
    [data setUsername:[thisPost username]];
    
    // Create an instance of the 3-dot view controller
    ThreeDotViewController *threeDot = [[ThreeDotViewController alloc] initWithThreeDotDataObject:data];
    
    // Set up modal presentation properties
    [threeDot setModalPresentationStyle:UIModalPresentationCustom];
    [threeDot setTransitioningDelegate:self];
    
    // Present the Three Dot view controller
    [[self parentViewController] presentViewController:threeDot animated:YES completion:nil];
}

#pragma mark - Custom modal animation for 3-dot
// Presenting the Three Dot drawer
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    // Only return an animator if the ThreeDotViewController is asking to be presented
    if([presented isKindOfClass:[ThreeDotViewController class]])
    {
        ThreeDotTransitionAnimator *animator = [[ThreeDotTransitionAnimator alloc] init];
        [animator setPresenting:YES];
        
        return animator;
    }
    else
        return nil;
}

// Dismissing the Three Dot drawer
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    // Only return an animator if the ThreeDotViewController is asking to be dismissed
    if([dismissed isKindOfClass:[ThreeDotViewController class]])
    {
        ThreeDotTransitionAnimator *animator = [[ThreeDotTransitionAnimator alloc] init];
        [animator setPresenting:NO];
        
        return animator;
    }
    else
        return nil;
}

#pragma mark - Handling of UIRefreshControl
// Called whenever the UIRefreshControl starts or stops refreshing
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    // Start the reload process if the refresh control is refreshing
    if([refreshControl isRefreshing])
        [[self dataController] reloadAllPosts];
}

// Called when the FeedDataController has removed some posts
//- (void)feedDataController:(FeedDataController *)feedDataController didRemovePostsAtIndexPaths:(NSArray *)indexPaths
//{
//    // Remove the given index paths
//    [[self tableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
//}

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
