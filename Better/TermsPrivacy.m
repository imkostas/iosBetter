//
//  TermsPrivacy.m
//  Better
//
//  Created by Peter on 6/11/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "TermsPrivacy.h"

@interface TermsPrivacy ()

@end

@implementation TermsPrivacy

#pragma mark - ViewController management

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set tint color of tab bar
	[[super tabBar] setTintColor:COLOR_BETTER_DARK];
	
	// Set tab bar delegate to ourselves
	[self setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Set the current tab
	if([self openingTabIndex] < [[[super tabBar] items] count])
	{
		[super setSelectedIndex:[self openingTabIndex]];
		[self setTitle:[[super selectedViewController] title]];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarController delegate methods
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	// Set the title of the tab bar controller accordingly
	[self setTitle:[viewController title]];
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

@end
