//
//  Settings.m
//  Better
//
//  Created by Peter on 6/9/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings

#pragma mark - ViewController management
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set up the navigation bar
	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation bar buttons
// Called when back arrow is pressed
- (IBAction)backArrowPressed:(id)sender
{
	// Dismiss this view controller (shows the Feed again)
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
