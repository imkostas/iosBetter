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
}

// Dummy objects for sizing real cells
@property (strong, nonatomic) FeedCell *dummyCell;
@property (strong, nonatomic) UILabel *dummyTagsLabel;

/** Placeholder images for profile picture */
@property (strong, nonatomic) UIImage *profPicPlaceholderFemale;
@property (strong, nonatomic) UIImage *profPicPlaceholderMale;

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
    
    // Get placeholder images
    _profPicPlaceholderFemale = [UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_FEMALE];
    _profPicPlaceholderMale = [UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_MALE];
	
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
    
    // Get UserInfo object
    UserInfo *user = [UserInfo user];
    
    // Generate different cells based on the type of the post
    FeedCell *cell = nil;
    switch([thisPost layoutType])
    {
        case LAYOUTSTATE_A_ONLY: // One image only
        {
            FeedCellSingleImage *thisCell = [tableView dequeueReusableCellWithIdentifier:@"feedCellSingleImage" forIndexPath:indexPath];
            cell = thisCell;
            
            // Clear images in case one is still visible from a previously used cell
            [[thisCell mainImageView] setImage:nil];
            
            // Set up images
            NSString *urlString = [[[UserInfo user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"post/%i_1.png", [thisPost postID]]];
            NSURL *url = [NSURL URLWithString:urlString];
            [[thisCell mainImageView] setImageWithURL:url];
            
            break;
        }
        case LAYOUTSTATE_LEFT_RIGHT: // Two images, side by side
        {
            FeedCellLeftRight *thisCell = [tableView dequeueReusableCellWithIdentifier:@"feedCellLeftRight" forIndexPath:indexPath];
            cell = thisCell;
            
            // Clear images in case one is still visible from a previously used cell
            [[thisCell leftImageView] setImage:nil];
            [[thisCell rightImageView] setImage:nil];
            
            // Set up images
            NSString *urlStringA = [[[UserInfo user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"post/%i_1.png", [thisPost postID]]];
            NSString *urlStringB = [[[UserInfo user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"post/%i_2.png", [thisPost postID]]];
            NSURL *urlA = [NSURL URLWithString:urlStringA];
            NSURL *urlB = [NSURL URLWithString:urlStringB];
            [[thisCell leftImageView] setImageWithURL:urlA];
            [[thisCell rightImageView] setImageWithURL:urlB];
            
            break;
        }
        case LAYOUTSTATE_TOP_BOTTOM: // Two images, top and bottom
        {
            FeedCellTopBottom *thisCell = [tableView dequeueReusableCellWithIdentifier:@"feedCellTopBottom" forIndexPath:indexPath];
            cell = thisCell;
            
            // Clear images in case one is still visible from a previously used cell
            [[thisCell topImageView] setImage:nil];
            [[thisCell bottomImageView] setImage:nil];
            
            // Set up images
            NSString *urlStringA = [[[UserInfo user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"post/%i_1.png", [thisPost postID]]];
            NSString *urlStringB = [[[UserInfo user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"post/%i_2.png", [thisPost postID]]];
            NSURL *urlA = [NSURL URLWithString:urlStringA];
            NSURL *urlB = [NSURL URLWithString:urlStringB];
            [[thisCell topImageView] setImageWithURL:urlA];
            [[thisCell bottomImageView] setImageWithURL:urlB];
            
            break;
        }
        default:
            return nil;
    }
    
    // Now load the profile picture
    NSString *profPicString = [[user s3_url] stringByAppendingString:[NSString stringWithFormat:@"user/%i_small.png", [thisPost userID]]];
    NSURL *profPicURL = [NSURL URLWithString:profPicString];
    UIImage *placeholderImage = ([user gender] == GENDER_FEMALE) ? _profPicPlaceholderFemale : _profPicPlaceholderMale;
    [[cell profileImageView] setImageWithURL:profPicURL placeholderImage:placeholderImage];
    
    // Populate the cell's UI elements
    [[cell tagsLabel] setAttributedText:[thisPost tagsAttributedString]];
//    [[cell tagsLabel] setText:[[thisPost tagsAttributedString] string]];
    [[cell usernameLabel] setText:[thisPost username]];
    [[cell numberOfVotesLabel] setText:[NSString stringWithFormat:@"%i", [thisPost numberOfVotesTotal]]];
    
    // Set up hotspots
    if([thisPost myVote] == VoteChoiceNoVote) // No vote by this user
    {
        // Hide other peoples' votes, enable taps
        [cell setHotspotGesturesEnabled:YES];
        [[cell hotspotA] setShowsPercentageValue:NO];
        [[cell hotspotB] setShowsPercentageValue:NO];
    }
    else // There is a vote by this user
    {
        // Turn off hotspot taps
        [cell setHotspotGesturesEnabled:NO];
        [[cell hotspotA] setShowsPercentageValue:YES];
        [[cell hotspotB] setShowsPercentageValue:YES];
        
        // Set highlighted or not highlighted
        if([thisPost numberOfVotesForA] == [thisPost numberOfVotesForB]) // A == B
        {
            [[cell hotspotA] setHighlighted:YES];
            [[cell hotspotB] setHighlighted:YES];
        }
        else if([thisPost numberOfVotesForA] < [thisPost numberOfVotesForB]) // A < B
        {
            [[cell hotspotA] setHighlighted:NO];
            [[cell hotspotB] setHighlighted:YES];
        }
        else // A > B
        {
            [[cell hotspotA] setHighlighted:YES];
            [[cell hotspotB] setHighlighted:NO];
        }
            
        // Calculate portions and apply them
        float percentA = (float)[thisPost numberOfVotesForA] / (float)[thisPost numberOfVotesTotal];
        float percentB = (float)[thisPost numberOfVotesForB] / (float)[thisPost numberOfVotesTotal];
        [[cell hotspotA] setPercentageValue:percentA];
        [[cell hotspotB] setPercentageValue:percentB];
    }
    
    // Set the cell's delegate to this object, to be notified of hotspot and 3-dot button taps
    // Also tell the cell which PostObject it is associated to
    [cell setDelegate:self];
//    [cell setPostObject:thisPost];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [[self dataController] numberOfPosts];
    else
        return 0;
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

// Called to tell this object to scroll back to the beginning of all the posts
- (void)feedDataControllerDelegateShouldScrollToTopAnimated:(BOOL)animated
{
    // Set content offset to zero
    CGPoint contentOffset = [[self tableView] contentOffset];
    if(contentOffset.y != 0)
        [[self tableView] setContentOffset:CGPointZero animated:animated];
}

#pragma mark - FeedCellDelegate methods
// Called when a cell's 3-dot button is pressed
- (void)threeDotButtonWasTappedForFeedCell:(FeedCell *)cell
{
    // Get this post's hashtags (-indexPathForCell returns nil if the cell is not visible, but the cell
    // has to be visible for the 3-dot button to be tapped, so it works in this case)
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    if(indexPath == nil)
        return; // Cell somehow not visible
    
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    
    // Create an instance of the 3-dot view controller
    ThreeDotViewController *threeDot = [[ThreeDotViewController alloc] initWithPostObject:thisPost];

    // Create a UINavigationController to allow the ThreeDotViewController to navigate to the 'Voters'
    // viewcontroller
    UINavigationController *threeDotNav = [[UINavigationController alloc] initWithRootViewController:threeDot];
    
    // Set up modal presentation properties and delegate
    [threeDotNav setModalPresentationStyle:UIModalPresentationCustom];
    [threeDotNav setTransitioningDelegate:self];
    [threeDotNav setDelegate:threeDot];
    
    // Set color and tint color of navigation bar (shown in the 'Voters' area)
    [[threeDotNav navigationBar] setBarTintColor:COLOR_BETTER_DARK];
    [[threeDotNav navigationBar] setTintColor:[UIColor whiteColor]];
    [[threeDotNav navigationBar] setTranslucent:NO];
    
    // Present the Three Dot view controller's navigation controller
    [self presentViewController:threeDotNav animated:YES completion:nil];
}

// Called when a cell's hotspot is pressed
- (void)hotspotWasTappedForFeedCell:(FeedCell *)cell withVoteChoice:(VoteChoice)choice
{
    // Disable the hotspot gesture recognizers on this cell
    [cell setHotspotGesturesEnabled:NO];
    
    // Get the cell's postObject (the assumption is that the user can't tap on a hotspot for a cell that is
    // not visible, which I think is true)
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
    if(indexPath == nil)
        return; // nil happens when the cell is not visible
    
    // Increment the total number of votes, increment number of votes for A, and set myVote to VoteChoiceA
    PostObject *thisPost = [[self dataController] postAtIndexPath:indexPath];
    [thisPost setNumberOfVotesTotal:([thisPost numberOfVotesTotal] + 1)];
    switch(choice) // Add a vote with the correct choice
    {
        case VoteChoiceA:
            [thisPost setNumberOfVotesForA:([thisPost numberOfVotesForA] + 1)];
            [thisPost setMyVote:VoteChoiceA];
            break;
            
        case VoteChoiceB:
            [thisPost setNumberOfVotesForB:([thisPost numberOfVotesForB] + 1)];
            [thisPost setMyVote:VoteChoiceB];
            
        case VoteChoiceNoVote:
        default:
            break;
    }
    
    // Update the UI
    [[cell numberOfVotesLabel] setText:[NSString stringWithFormat:@"%i", [thisPost numberOfVotesTotal]]];
    
    // Turn off hotspot taps
    [[cell hotspotA] setShowsPercentageValue:YES];
    [[cell hotspotB] setShowsPercentageValue:YES];
    
    // Set highlighted or not highlighted
    if([thisPost numberOfVotesForA] == [thisPost numberOfVotesForB]) // A == B
    {
        [[cell hotspotA] setHighlighted:YES];
        [[cell hotspotB] setHighlighted:YES];
    }
    else if([thisPost numberOfVotesForA] < [thisPost numberOfVotesForB]) // A < B
    {
        [[cell hotspotA] setHighlighted:NO];
        [[cell hotspotB] setHighlighted:YES];
    }
    else // A > B
    {
        [[cell hotspotA] setHighlighted:YES];
        [[cell hotspotB] setHighlighted:NO];
    }
    
    // Calculate portions and apply them
    float percentA = (float)[thisPost numberOfVotesForA] / (float)[thisPost numberOfVotesTotal];
    float percentB = (float)[thisPost numberOfVotesForB] / (float)[thisPost numberOfVotesTotal];
    [[cell hotspotA] setPercentageValue:percentA];
    [[cell hotspotB] setPercentageValue:percentB];
    
    // Send off the vote request
    [[self dataController] voteWithChoice:choice atIndexPath:indexPath];
}

#pragma mark - Custom modal animation for 3-dot
// Presenting the Three Dot drawer
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    // Only return an animator if the ThreeDotViewController is asking to be presented
//    if([presented isKindOfClass:[ThreeDotViewController class]])
//    {
        ThreeDotTransitionAnimator *animator = [[ThreeDotTransitionAnimator alloc] init];
        [animator setPresenting:YES];
        
        return animator;
//    }
//    else
//        return nil;
}

// Dismissing the Three Dot drawer
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    // Only return an animator if the ThreeDotViewController is asking to be dismissed
//    if([dismissed isKindOfClass:[ThreeDotViewController class]])
//    {
        ThreeDotTransitionAnimator *animator = [[ThreeDotTransitionAnimator alloc] init];
        [animator setPresenting:NO];
        
        return animator;
//    }
//    else
//        return nil;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
