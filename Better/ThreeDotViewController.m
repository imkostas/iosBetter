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
    BOOL hasAlreadyLaidOutSubviews;
}

/** An array to hold labels for each row of the UITableView */
@property (strong, nonatomic) NSArray *rowLabels;

// Gesture recognizer for dismissing this view controller by tapping on its background
@property (strong, nonatomic) UITapGestureRecognizer *tapOnViewRecognizer;
- (void)tappedOnBackgroundView:(UITapGestureRecognizer *)gesture;

// UITableViewController for displaying details of this post (it is added as a child view controller)
@property (strong, nonatomic) UITableViewController *tableViewController;

// Constraints controlling the vertical position of the UITableView and its height
@property (weak, nonatomic) NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation ThreeDotViewController

#pragma mark - Initialization
- (instancetype)initWithThreeDotDataObject:(ThreeDotDataObject *)object
{
    self = [super init];
    if(self)
    {
        // Set up with the data object
        NSMutableArray *labels = [[NSMutableArray alloc] init];
        if([object hasVotes])
            [labels addObject:@"Voters"];
        
        if(![object isOwnPost])
        {
            [labels addObject:@"Favorite Post"];
            [labels addObject:[object username]];
        }
        
        for(NSString *tag in [object tags])
            [labels addObject:[@"#" stringByAppendingString:tag]];
        
        if(![object isOwnPost])
            [labels addObject:@"Report Misuse"];
        
        // Store
        [self setRowLabels:labels];
    }
    
    return self;
}

#pragma mark - ViewController management
// Create this thing's view programmatically
- (void)loadView
{
    // Initialize a view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    
    // Set it as the viewcontroller's view property
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize variables
    hasAlreadyLaidOutSubviews = FALSE;
    
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
    [[[self tableViewController] tableView] registerClass:[ThreeDotTableViewCell class] forCellReuseIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(!hasAlreadyLaidOutSubviews)
    {
        // Height of UIRefreshControl
        CGFloat refreshControlHeight = CGRectGetHeight([[[self tableViewController] refreshControl] bounds]);
        
        // Layout constraints for the UITableView:
        //   Align it to the left and right sides of its superview
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tbl]-0-|"
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

        // Only run once
        hasAlreadyLaidOutSubviews = TRUE;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
                         // start network process here
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Simulate loading some data
    
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
                         // Delete the UIRefreshControl (up to this point, it is just hidden beneath
                         // the contents of the UITableView)
                         [[[self tableViewController] refreshControl] endRefreshing];
                         [[self tableViewController] setRefreshControl:nil];
                         
                         // Re-enable the scroll indicators
                         [[[self tableViewController] tableView] setShowsVerticalScrollIndicator:YES];
                         [[[self tableViewController] tableView] flashScrollIndicators];
                     }];
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

#pragma mark - Table view data source

// There is only one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// The number of rows depends on the data being returned by the API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self rowLabels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_THREE_DOT_TABLEVIEW_CELL forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
// Set up the cell before it's displayed
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Different labels depending on flags inside ThreeDotDataObject
    
    // Retrieve the corresponding row label from `rowLabel`
    NSString *rowLabel = [[self rowLabels] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:rowLabel];
    
    // Set selected style if this is the "Voters" label, otherwise, set selected style to none
    if([rowLabel isEqualToString:@"Voters"])
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    else
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Set the picture correctly
    // ...
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"3-dot selected row at row: %i", [indexPath row]);
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
