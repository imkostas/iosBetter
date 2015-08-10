//
//  ThreeDotViewController.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotViewController.h"

@interface ThreeDotViewController ()
{
    // Only add constraints once
    BOOL alreadyLaidOutSubviews;
    
    // Only slide up the UITableView from the bottom once
    BOOL alreadyPresentedTableViewController;
    
    // Only resize the UITableView's height once
    BOOL alreadyResizedTableViewController;
}

/** An array to hold labels for each row of the UITableView (either NSStrings or NSAttributedString) */
@property (strong, nonatomic) NSArray *rowLabels;

/** Holds the username of the poster, passed by the given ThreeDotDataObject */
@property (strong, nonatomic) NSString *username;

/** Holds the PostObject associated with this object */
@property (weak, nonatomic) PostObject *postObject;

// Gesture recognizer for dismissing this view controller by tapping on its background
@property (strong, nonatomic) UITapGestureRecognizer *tapOnViewRecognizer;
- (void)tappedOnBackgroundView:(UITapGestureRecognizer *)gesture;

// UITableViewController for displaying details of this post (it is added as a child view controller)
@property (strong, nonatomic) UITableViewController *tableViewController;

// Constraints controlling the vertical position of the UITableView and its height
@property (weak, nonatomic) NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) NSLayoutConstraint *tableViewHeightConstraint;

// UIImage objects for each icon
@property (strong, nonatomic) UIImage *iconDisclosure;
@property (strong, nonatomic) UIImage *iconFavoriteUnfilled;
@property (strong, nonatomic) UIImage *iconFavoriteFilled;
@property (strong, nonatomic) UIImage *iconAddPersonUnfilled;
@property (strong, nonatomic) UIImage *iconAddPersonFilled;
@property (strong, nonatomic) UIImage *iconReportMisuse;

@end

@implementation ThreeDotViewController

#pragma mark - Initialization
- (instancetype)initWithPostObject:(PostObject *)post
{
    self = [super init];
    if(self)
    {
        // Initialize //
        
        // Flags
        alreadyLaidOutSubviews = FALSE;
        alreadyPresentedTableViewController = FALSE;
        alreadyResizedTableViewController = FALSE; // not used anymore
        
        // Other variables
        _postObject = post;
        _dataController = [[ThreeDotDataController alloc] init];
        [_dataController setDelegate:self];
        
        // Load icon images
        _iconAddPersonUnfilled = [UIImage imageNamed:ICON_PERSON_ADD];
        _iconAddPersonFilled = [UIImage imageNamed:ICON_PERSON_ADDED];
        _iconFavoriteUnfilled = [UIImage imageNamed:ICON_FAVORITE_OUTLINE_LIGHT];
        _iconFavoriteFilled = [UIImage imageNamed:ICON_FAVORITED];
        _iconReportMisuse = [UIImage imageNamed:ICON_WARNING];
    }
    
    return self;
}

#pragma mark - ViewController management
// Create this thing's view programmatically
- (void)loadView
{
    // Initialize a view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    // Set it as the viewcontroller's view property
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Keep from adding unnecessary space to the top of the UITableView child
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    // Set up the tap gesture recognizer and add it to the view [self view]
    _tapOnViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnBackgroundView:)];
    [[self tapOnViewRecognizer] setDelegate:self];
    [[self view] addGestureRecognizer:[self tapOnViewRecognizer]];
    
    // Set up the UITableViewController
    _tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // UIRefreshControl
    UIRefreshControl *rfControl = [[UIRefreshControl alloc] init];
    [[self tableViewController] setRefreshControl:rfControl];
    
    // Add the UITableViewController as a child
    [self addChildViewController:[self tableViewController]];
    [[self tableViewController] didMoveToParentViewController:self];
    [[self view] addSubview:[[self tableViewController] view]];
    
    // Set up the UITableView of the above viewcontroller
    [[[self tableViewController] tableView] setDataSource:self];
    [[[self tableViewController] tableView] setDelegate:self];
    [[[self tableViewController] tableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[[self tableViewController] tableView] setRowHeight:HEIGHT_3DOT_MENU_ROW];
    
    // Set up the reusable tableview cell
//    [[[self tableViewController] tableView] registerClass:[ThreeDotTableViewCell class] forCellReuseIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL];
    [[[self tableViewController] tableView] registerNib:[UINib nibWithNibName:@"ThreeDotTableViewCell" bundle:nil] forCellReuseIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(!alreadyLaidOutSubviews)
    {
        // Height of UIRefreshControl
        CGFloat refreshControlHeight = CGRectGetHeight([[[self tableViewController] refreshControl] bounds]);
        
        // Layout constraints for the UITableView:
        //   Align it to the left and right sides of its superview
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tbl]|"
                                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                      metrics:nil
                                                                                        views:@{@"tbl":[[self tableViewController] view]}];
        //   Set the UITableView's height for now to the height of the UIRefreshControl
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:[[self tableViewController] view]
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:refreshControlHeight];
        [self setTableViewHeightConstraint:height]; // Save reference
        
        // Set the bottom of the UITableView to the bottom of its superview, plus its own height (to hide it)
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:[[self tableViewController] view]
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:[self view]
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:refreshControlHeight];
        [self setTableViewBottomConstraint:bottom]; // Save reference
        
        [[self view] addConstraint:bottom];
        [[self view] addConstraints:horizontalConstraints];
        [[[self tableViewController] view] addConstraint:height];
        
        // Push the UITableView's content down to make sure the UIRefreshControl is visible
        [[[self tableViewController] tableView] setContentOffset:CGPointMake(0, -refreshControlHeight) animated:NO];

        // Only run once
        alreadyLaidOutSubviews = TRUE;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"view will appear");
    
    // De-select a previously selected row, if any
    NSIndexPath *selectedRow = [[[self tableViewController] tableView] indexPathForSelectedRow];
    if(selectedRow)
        [[[self tableViewController] tableView] deselectRowAtIndexPath:selectedRow animated:YES];
    
    if(!alreadyPresentedTableViewController)
    {
        // Start the refresh animation
        [[[self tableViewController] refreshControl] beginRefreshing];
        
        // Start the download process
        [[self dataController] reloadDataWithPostObject:[self postObject]];

        // Animate the tableview
        [[self view] layoutIfNeeded];
        [UIView animateWithDuration:ANIM_DURATION_3DOT_MENU_TABLEVIEW
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [[self tableViewBottomConstraint] setConstant:0];
                             [[self view] layoutIfNeeded];
                         }
                         completion:^(BOOL completed){
                             // Only bring up from bottom once
                             alreadyPresentedTableViewController = TRUE;
                         }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"view did appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture recognizer handlers
- (void)tappedOnBackgroundView:(UITapGestureRecognizer *)gesture
{
    // Stop refreshing if it is visible
    if([[[self tableViewController] refreshControl] isRefreshing])
        [[[self tableViewController] refreshControl] endRefreshing];
    
    // Animate away the UITableView
//    [[self view] layoutIfNeeded];
//    [UIView animateWithDuration:ANIM_DURATION_3DOT_MENU
//                          delay:0
//         usingSpringWithDamping:1
//          initialSpringVelocity:0
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         [[self tableViewBottomConstraint] setConstant:[[self tableViewHeightConstraint] constant]];
//                         [[self view] layoutIfNeeded];
//                     }
//                     completion:nil];
    
    // Dismiss this view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called when the tap to dismiss gesture recognizer is received
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(gestureRecognizer == [self tapOnViewRecognizer])
    {
        // Do not dismiss the view controller if the user pressed inside the UITableView
        CGPoint touchPoint = [touch locationInView:[self view]];
        return !CGRectContainsPoint([[[self tableViewController] view] frame], touchPoint);
    }
    else
        return YES;
}

#pragma mark - UITableViewDataSource methods
// There is only one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// The number of rows depends on the data being returned by the API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    NSLog(@"number of rows: %i", (int)[[self dataController] numberOfItems]);
    return [[self dataController] numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a cell
    ThreeDotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL forIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate methods
// Set up the cell before it's displayed
- (void)tableView:(UITableView *)tableView willDisplayCell:(ThreeDotTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{   
    // Retrieve the correct object for this indexPath
    ThreeDotObject *threeDotObject = [[self dataController] itemAtIndexPath:indexPath];
    
    // Configure the cell based on its ThreeDotObject
    switch([threeDotObject type])
    {
        case ThreeDotObjectTypeVoters:
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [[cell icon] setImage:nil];
            [[cell label] setText:[threeDotObject title]];
            
            break;
        }
        case ThreeDotObjectTypeFavoritePost:
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            // Favorite or un-favorited
            if([threeDotObject isActive])
                [[cell icon] setImage:[self iconFavoriteFilled]];
            else
                [[cell icon] setImage:[self iconFavoriteUnfilled]];
            
            [[cell label] setText:[threeDotObject title]];
            
            break;
        }
        case ThreeDotObjectTypeUsername:
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            // Added or not added (following)
            if([threeDotObject isActive])
                [[cell icon] setImage:[self iconAddPersonFilled]];
            else
                [[cell icon] setImage:[self iconAddPersonFilled]];
            
            [[cell label] setText:[threeDotObject title]];
            
            break;
        }
        case ThreeDotObjectTypeHashtag:
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            // Favorite or un-favorited
            if([threeDotObject isActive])
                [[cell icon] setImage:[self iconFavoriteFilled]];
            else
                [[cell icon] setImage:[self iconFavoriteUnfilled]];
            
            [[cell label] setAttributedText:[threeDotObject attributedTitle]];
//            [[cell label] setText:[[threeDotObject attributedTitle] string]];
            
            break;
        }
        case ThreeDotObjectTypeReportMisuse:
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [[cell icon] setImage:[self iconReportMisuse]];
            [[cell label] setText:STRING_REPORT_MISUSE];
            
            break;
        }
        default:
            break;
    }
}

// Called whenever a cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"3-dot selected row at row: %i", (int)[indexPath row]);
    
    // Retrieve the correct object for this indexPath
    ThreeDotObject *thisObject = [[self dataController] itemAtIndexPath:indexPath];
    
    switch([thisObject type])
    {
        case ThreeDotObjectTypeVoters:
        {
            UIViewController *hey = [[UIViewController alloc] init];
            [hey setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
            [[hey view] setBackgroundColor:[UIColor whiteColor]];
            [[self navigationController] pushViewController:hey animated:YES];
            
            break;
        }
        case ThreeDotObjectTypeFavoritePost:
        case ThreeDotObjectTypeUsername:
        case ThreeDotObjectTypeHashtag:
        case ThreeDotObjectTypeReportMisuse:
        default:
            [[[self tableViewController] tableView] deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
    
    /*
    // Retrieve the cell corresponding to this indexPath
    UITableViewCell *cell = [[[self tableViewController] tableView] cellForRowAtIndexPath:indexPath];
    
    switch([cell tag])
    {
        case ThreeDotTableViewCellTypeVoters:
        {
            UIViewController *hey = [[UIViewController alloc] init];
            [hey setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
            [[hey view] setBackgroundColor:[UIColor whiteColor]];
            [[self navigationController] pushViewController:hey animated:YES];
            
            break;
        }
        default:
            [[[self tableViewController] tableView] deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }*/
}

#pragma mark - UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Show the nav bar if we are showing a view controller other than this ThreeDotViewController
    if(viewController == self)
        [navigationController setNavigationBarHidden:YES animated:animated]; // Hide only when this ThreeDotVC is being shown
    else
        [navigationController setNavigationBarHidden:NO animated:animated]; // e.g. the Voters view controller
}

#pragma mark - ThreeDotDataControllerDelegate methods
- (void)threeDotDataController:(ThreeDotDataController *)threeDotDataController didLoadItemsAtIndexPaths:(NSArray *)indexPaths
{
    // Reload the UITableView at the given index paths
    [[[self tableViewController] tableView] reloadData];
    
    // Animate the UITableView's height
    [[[self tableViewController] tableView] setShowsVerticalScrollIndicator:NO];
    [[self view] layoutIfNeeded];
    [UIView animateWithDuration:ANIM_DURATION_3DOT_MENU_TABLEVIEW
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Scroll the UITableView up to hide the UIRefreshControl, as opposed to calling
                         // -endRefreshing and setting it to nil, which causes animation stutters
                         [[[self tableViewController] tableView] setContentOffset:CGPointZero];
                         
                         // Resize the TableView's height to the height of its contentSize, but limit it to
                         // a certain portion of the screen height
                         CGFloat tableViewContentHeight = [[[self tableViewController] tableView] contentSize].height;
                         CGFloat heightLimit = SCREEN_HEIGHT * 0.65;
                         if(tableViewContentHeight > heightLimit)
                             tableViewContentHeight = heightLimit;
                         
                         // Apply the new height and run the layout
                         [[self tableViewHeightConstraint] setConstant:tableViewContentHeight];
                         [[self view] layoutIfNeeded];
                     }
                     completion:^(BOOL completion){
                         // Do not animate again
                         alreadyResizedTableViewController = TRUE;
                         
                         // Delete the UIRefreshControl (up to this point, it is just hidden beneath
                         // the contents of the UITableView)
                         [[[self tableViewController] refreshControl] endRefreshing];
                         [[self tableViewController] setRefreshControl:nil];
                         
                         // Re-enable the scroll indicators
                         [[[self tableViewController] tableView] setShowsVerticalScrollIndicator:YES];
                         [[[self tableViewController] tableView] flashScrollIndicators];
                     }];
}

@end
