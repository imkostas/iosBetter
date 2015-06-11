//
//  Notifications.m
//  Better
//
//  Created by Peter on 6/11/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Notifications.h"

@interface Notifications ()

@end

@implementation Notifications

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set background color
	[[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// The following are called when the switches are toggled:

- (IBAction)votesOnPostValueChanged:(id)sender
{
	NSLog(@"Notifications - Votes on Post now: %i", [sender isOn]);
}

- (IBAction)favoritesPostValueChanged:(id)sender
{
	NSLog(@"Notifications - Favorites my Post now: %i", [sender isOn]);
}

- (IBAction)gainFollowerValueChanged:(id)sender
{
	NSLog(@"Notifications - Gain follower now: %i", [sender isOn]);
}
@end
