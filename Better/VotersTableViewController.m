//
//  Voters.m
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "VotersTableViewController.h"

@interface VotersTableViewController ()

/** How many rows to load at a time */
@property (nonatomic) int maxNumberOfVotersPerDownload;

/** Reference to userinfo */
@property (weak, nonatomic) UserInfo *user;

/** Placeholder images for profile picture */
@property (strong, nonatomic) UIImage *profPicPlaceholderFemale;
@property (strong, nonatomic) UIImage *profPicPlaceholderMale;

/** Called when the refresh control is activated/deactivated */
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl;

@end

@implementation VotersTableViewController

#pragma mark - Init
- (instancetype)initWithPostObject:(PostObject *)postObject
{
    self = [super init];
    if(self)
    {
        // Initialize data controller
        _dataController = [[VotersDataController alloc] initWithPostObject:postObject];
        _maxNumberOfVotersPerDownload = 0;
        _user = [UserInfo user];
    }
    
    return self;
}

#pragma mark - ViewController management

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set this title
    [self setTitle:@"Voters"];
    
    // Set delegate for VotersDataController
    [[self dataController] setDelegate:self];
    
    // Set up the UITableView
    [[self tableView] setBackgroundColor:COLOR_GRAY];
    [[self tableView] registerNib:[UINib nibWithNibName:@"VotersTableViewCell" bundle:nil] forCellReuseIdentifier:REUSE_ID_VOTERS_TABLEVIEW_CELL];
    [[self tableView] setRowHeight:50];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Set up refresh control
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [[self refreshControl] setTintColor:COLOR_BETTER_DARK];
    [[self refreshControl] addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Get placeholder images
    _profPicPlaceholderFemale = [UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_FEMALE];
    _profPicPlaceholderMale = [UIImage imageNamed:IMAGE_EMPTY_PROFILE_PICTURE_MALE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load some data
    _maxNumberOfVotersPerDownload = CGRectGetHeight([[self tableView] bounds]) / [[self tableView] rowHeight];
    [[self refreshControl] beginRefreshing];
    [[self dataController] loadVotersIncrementalWithLimit:[self maxNumberOfVotersPerDownload]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a cell
    VotersTableViewCell *cell = (VotersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_VOTERS_TABLEVIEW_CELL forIndexPath:indexPath];
    [cell setBackgroundColor:COLOR_GRAY];
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    // Create a darker background view
    UIView *backgroundView = [[UIView alloc] initWithFrame:[cell bounds]];
    [backgroundView setBackgroundColor:COLOR_GRAY_DARKER];
    [cell setSelectedBackgroundView:backgroundView];
    
    // Set up the cell
    VoterObject *thisVoter = [[self dataController] voterObjectAtIndexPath:indexPath];
    [[cell usernameLabel] setText:[thisVoter username]];
    
    // Set up the icon
    if([thisVoter userID] == [[self user] userID])
        // This is ourselves -- do not show an icon
        [[cell icon] setImage:nil];
    else // A different user than the currently logged in user
    {
        if([thisVoter isActive])
            [[cell icon] setImage:[UIImage imageNamed:ICON_PERSON_ADDED]];
        else
            [[cell icon] setImage:[UIImage imageNamed:ICON_PERSON_ADD]];
    }
    
    // Set up profile picture
    NSString *profPicString = [[[self user] s3_url] stringByAppendingString:[NSString stringWithFormat:@"user/%i_small.png", [thisVoter userID]]];
    NSURL *profPicURL = [NSURL URLWithString:profPicString];
    UIImage *placeholderImage = ([[self user] gender] == GENDER_FEMALE) ? _profPicPlaceholderFemale : _profPicPlaceholderMale;
    [[cell profilePictureView] setImageWithURL:profPicURL placeholderImage:placeholderImage];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return [[self dataController] numberOfVoterObjects];
    else
        return 0;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Send off the request
    [[self dataController] toggleActiveStateForIndexPath:indexPath];
    
    // Deselect the row right now
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the VoterObject for this indexPath
    VoterObject *thisVoter = [[self dataController] voterObjectAtIndexPath:indexPath];
    
    // Do not allow a highlight if this row is currently changing, OR the row corresponds to the current user
    if([thisVoter isChangingActiveState] || [thisVoter userID] == [[self user] userID])
        return NO;
    else
        return YES;
}

#pragma mark - VotersDataControllerDelegate methods
- (void)votersDataController:(VotersDataController *)votersDataController didLoadVotersAtIndexPaths:(NSArray *)loadedPaths removeVotersAtIndexPaths:(NSArray *)removedPaths
{
    // Insert the given index paths
    [[self tableView] beginUpdates];
    [[self tableView] deleteRowsAtIndexPaths:removedPaths withRowAnimation:UITableViewRowAnimationLeft];
    [[self tableView] insertRowsAtIndexPaths:loadedPaths withRowAnimation:UITableViewRowAnimationRight];
    [[self tableView] endUpdates];
    
    // Stop the UIRefreshControl
    if([[self refreshControl] isRefreshing])
        [[self refreshControl] endRefreshing];
}

- (void)votersDataController:(VotersDataController *)votersDataController didReloadVotersAtIndexPaths:(NSArray *)reloadedPaths
{
    // Reload the given index paths
    [[self tableView] reloadRowsAtIndexPaths:reloadedPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UIRefreshControl management
- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl
{
    if([refreshControl isRefreshing])
        [[self dataController] reloadAllVotersWithLimit:[self maxNumberOfVotersPerDownload]];
}

@end
