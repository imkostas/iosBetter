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

// Will be removed
@property (strong, nonatomic) UILabel *helloLabel;

@end

@implementation ThreeDotViewController

#pragma mark - ViewController management
// Create this thing's view programmatically
- (void)loadView
{
    // Initialize a view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    // Set it as the viewcontroller's view property
    [self setView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the tap gesture recognizer and add it to the view [self view]
    _tapOnViewRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnBackgroundView:)];
    [[self view] addGestureRecognizer:[self tapOnViewRecognizer]];
    
    // Add a label for now
    _helloLabel = [[UILabel alloc] init];
    [_helloLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_helloLabel setText:@"Hello"];
    [_helloLabel setTextColor:[UIColor whiteColor]];
    [[self view] addSubview:_helloLabel];
}

- (void)viewWillLayoutSubviews
{
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:[self helloLabel]
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:[self view]
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:[self helloLabel]
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:[self view]
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1 constant:0];
    
    [[self view] addConstraint:centerX];
    [[self view] addConstraint:centerY];
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

#pragma mark - Table view data source

// There is only one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// The number of rows depends on the data being returned by the API
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

// No highlighting, except for the Voters row (if it exists)
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
