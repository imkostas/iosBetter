//
//  Menu.m
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Menu.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Set the profile image
	[[[self profileImageView] layer] setMasksToBounds:YES];
	//	[[[self profileImageView] layer] setShouldRasterize:YES]; // For performance?
	[[[self profileImageView] layer] setCornerRadius:[[self profileImageView] frame].size.height / 2];
	[[self profileImageView] setImage:[UIImage imageNamed:@"donkey"]];
	
	// Set up gesture recognizers
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

@end
