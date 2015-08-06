//
//  ThreeDotViewController.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotViewController.h"

#define STRING_VOTERS @"Voters"
#define STRING_FAVORITE_POST @"Favorite Post"
#define STRING_REPORT_MISUSE @"Report Misuse"

/** An enumeration used in the `tag` property of a UITableViewCell to identify the cell's purpose. Values start
 at one rather than zero because a UIView's default tag number is zero. */
typedef NS_ENUM(NSUInteger, ThreeDotTableViewCellType) {
    /** A cell representing the "Voters" row of the UITableView */
    ThreeDotTableViewCellTypeVoters = 1,
    /** A cell representing the "Favorite Post" row of the UITableView */
    ThreeDotTableViewCellTypeFavoritePost = 2,
    /** A cell representing the <USERNAME HERE> row of the UITableView */
    ThreeDotTableViewCellTypeUsername = 3,
    /** A cell representing a hashtag row of the UITableView */
    ThreeDotTableViewCellTypeHashtag = 4,
    /** A cell representing the "Report Misuse" row of the UITableView */
    ThreeDotTableViewCellTypeReportMisuse = 5
};

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

/** Holds the username of the post-er, passed by the given ThreeDotDataObject */
@property (strong, nonatomic) NSString *username;

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
- (instancetype)initWithThreeDotDataObject:(ThreeDotDataObject *)object
{
    self = [super init];
    if(self)
    {
        // Initialize variables
        alreadyLaidOutSubviews = FALSE;
        alreadyPresentedTableViewController = FALSE;
        alreadyResizedTableViewController = FALSE;
        
        // Set up with the data object
        NSMutableArray *labels = [[NSMutableArray alloc] init];
        
        if([object hasVotes])
            [labels addObject:STRING_VOTERS];
        
        // Add "Favorite Post" and the username rows if this post is not the user's own post
        if(![object isOwnPost])
        {
            [labels addObject:STRING_FAVORITE_POST];
            [labels addObject:[object username]];
        }
        
        // Add the hashtags in as NSAttributedStrings
        for(NSString *tag in [object tags])
        {
            NSString *tagWithHash = [@"#" stringByAppendingString:tag];
            
            // Color the "#" a lighter gray
            NSMutableAttributedString *hashtagString = [[NSMutableAttributedString alloc] initWithString:tagWithHash];
            NSRange firstCharRange = { .location = 0, .length = 1 };
            [hashtagString beginEditing];
            [hashtagString addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_STOCK range:firstCharRange];
            [hashtagString endEditing];
            
            // Add this attributed string to the array
            [labels addObject:hashtagString];
        }
        
        // Add the Report Misuse row if this post is not the user's own post
        if(![object isOwnPost])
            [labels addObject:STRING_REPORT_MISUSE];
        
        // Save data
        [self setRowLabels:labels];
        [self setUsername:[object username]];
        
        // Load icon images
        _iconAddPersonUnfilled = [UIImage imageNamed:ICON_PERSON_ADD];
//        _iconAddPersonFilled = ...
        _iconFavoriteUnfilled = [UIImage imageNamed:ICON_FAVORITE_OUTLINE];
//        _iconFavoriteFilled = ...
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
                             
                             // start network process here
                         }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Simulate loading some data
    
    NSLog(@"view did appear");
    
    if(!alreadyResizedTableViewController)
    {
        // Reload TableView rows
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
    else // Just flash the scroll indicators
        [[[self tableViewController] tableView] flashScrollIndicators];
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
    NSLog(@"number of rows: %i", [[self rowLabels] count]);
    return [[self rowLabels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a cell
    ThreeDotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL forIndexPath:indexPath];
    
    //// Set its tag now to identify it later ////
    
    // Retrieve either an NSString or an NSAttributedString
    NSObject *rowLabel = [[self rowLabels] objectAtIndex:[indexPath row]];
    if([rowLabel isKindOfClass:[NSString class]])
    {
        // We know it's not a hashtag cell
        NSString *rowLabelString = (NSString *)rowLabel;
        
        if([rowLabelString isEqualToString:STRING_VOTERS])
            // This is the Voters row, set tag accordingly
            [cell setTag:ThreeDotTableViewCellTypeVoters];
        
        else if([rowLabelString isEqualToString:STRING_FAVORITE_POST])
            // This is the Favorite Post row
            [cell setTag:ThreeDotTableViewCellTypeFavoritePost];
        
        else if([rowLabelString isEqualToString:STRING_REPORT_MISUSE])
            // This is the Report Misuse row
            [cell setTag:ThreeDotTableViewCellTypeReportMisuse];
        
        else if([rowLabelString isEqualToString:[self username]])
            // This is the <username> row
            [cell setTag:ThreeDotTableViewCellTypeUsername];
    }
    else if([rowLabel isKindOfClass:[NSAttributedString class]])
        // We know it's a hashtag cell
        [cell setTag:ThreeDotTableViewCellTypeHashtag];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
// Set up the cell before it's displayed
- (void)tableView:(UITableView *)tableView willDisplayCell:(ThreeDotTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Different labels depending on the cell's tag
    switch([cell tag])
    {
        case ThreeDotTableViewCellTypeVoters:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault]; // Able to be highlighted
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [[cell icon] setImage:nil];
            [[cell label] setText:STRING_VOTERS];
            
            break;
        }
        case ThreeDotTableViewCellTypeFavoritePost:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // No highlighting
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [[cell icon] setImage:[self iconAddPersonUnfilled]];
            [[cell label] setText:STRING_FAVORITE_POST];
            
            break;
        }
        case ThreeDotTableViewCellTypeUsername:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // No highlighting
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [[cell icon] setImage:[self iconFavoriteUnfilled]];
            [[cell label] setText:[self username]];
            
            break;
        }
        case ThreeDotTableViewCellTypeHashtag:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // No highlighting
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [[cell icon] setImage:[self iconFavoriteUnfilled]];
            [[cell label] setAttributedText:[[self rowLabels] objectAtIndex:[indexPath row]]];
            
            break;
        }
        case ThreeDotTableViewCellTypeReportMisuse:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // No highlighting
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
    NSLog(@"3-dot selected row at row: %i", [indexPath row]);
    
    // Retrieve the cell corresponding to this indexPath
    UITableViewCell *cell = [[[self tableViewController] tableView] cellForRowAtIndexPath:indexPath];
    
    if([cell tag] == ThreeDotTableViewCellTypeVoters)
    {
        UIViewController *hey = [[UIViewController alloc] init];
        [hey setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
        [[hey view] setBackgroundColor:[UIColor whiteColor]];

        [[self navigationController] pushViewController:hey animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped accessory view for index path: %i", [indexPath row]);
}

#pragma mark - UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSLog(@"showing view controller: %@", viewController);
//    NSLog(@"I am %@", self);
//    NSLog(@"   the presenting vc is: %@", [viewController presentingViewController]);
    
    // Show the nav bar if we are showing a view controller other than this ThreeDotViewController
    if(viewController == self)
        [navigationController setNavigationBarHidden:YES animated:animated]; // Hide only when this ThreeDotVC is being shown
    else
        [navigationController setNavigationBarHidden:NO animated:animated]; // e.g. the Voters view controller
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
