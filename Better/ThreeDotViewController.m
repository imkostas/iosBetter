//
//  ThreeDotViewController.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotViewController.h"

@interface ThreeDotViewController ()

// Gesture recognizer for dismissing this view controller by tapping on its background
@property (strong, nonatomic) UITapGestureRecognizer *tapOnViewRecognizer;
- (void)tappedOnBackgroundView:(UITapGestureRecognizer *)gesture;

/*
// UITableViewController for displaying details of this post (it is added as a child view controller)
@property (strong, nonatomic) UITableViewController *tableViewController;

// A UIView to embed the UITableViewController's view inside
@property (strong, nonatomic) UIView *tableViewContainerView;
 */

@property (strong, nonatomic) UITableView *tableView;

// Constraint controlling the vertical position of the UITableView's container
@property (strong, nonatomic) NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation ThreeDotViewController

#pragma mark - ViewController management
// Create this thing's view programmatically
- (void)loadView
{
    // Initialize a view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    
    // Set it as the viewcontroller's view property
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the tap gesture recognizer and add it to the view [self view]
    _tapOnViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnBackgroundView:)];
    [[self tapOnViewRecognizer] setDelegate:self];
    [[self view] addGestureRecognizer:[self tapOnViewRecognizer]];
    
    // Set up the UITableViewController's container view
//    _tableViewContainerView = [[UIView alloc] init];
//    [[self tableViewContainerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [[self view] addSubview:[self tableViewContainerView]];
//    
//    // Set up the UITableViewController child
//    _tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
//    [self addChildViewController:[self tableViewController]];
//    [[self tableViewController] didMoveToParentViewController:self];
//    [[self tableViewContainerView] addSubview:[[self tableViewController] view]];
//    
//    // Set up the UITableView of the above viewcontroller
//    [[[self tableViewController] tableView] setDataSource:self];
//    [[[self tableViewController] tableView] setDelegate:self];
//    [[[self tableViewController] tableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [[self tableView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [[self view] addSubview:[self tableView]];
    
    // Set up the reusable tableview cell
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"my_reuse_id"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Layout constraints for the UITableView:
    //   Align it to the left and right sides of its superview
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tbl]-0-|"
                                                                                  options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                  metrics:nil
                                                                                    views:@{@"tbl":[self tableView]}];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:[self view]
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1 constant:300];
    self.tableViewBottomConstraint = bottom;
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:[self tableView]
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1 constant:300];
    [[self view] addConstraint:bottom];
    [[self view] addConstraints:horizontalConstraints];
    [[self tableView] addConstraint:height];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Animate the tableview
    [[self view] layoutIfNeeded];
    [UIView animateWithDuration:ANIM_DURATION_SHOW_3DOT_MENU
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [[self tableViewBottomConstraint] setConstant:0];
                         [[self view] layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture recognizer handlers
- (void)tappedOnBackgroundView:(UITapGestureRecognizer *)gesture
{
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
        return !CGRectContainsPoint([[self tableView] frame], touchPoint);
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"my_reuse_id" forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[cell textLabel] setText:@"Text here"];
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
