//
//  PostHashtagsViewController.m
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "PostHashtagsViewController.h"

@interface PostHashtagsViewController ()

@end

@implementation PostHashtagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set background color
    [[self view] setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
    
    // Make label bold
    [[self addTagsLabel] setEmphasized:YES];
    
    NSLog(@"coord A: (%.1f,%.1f)", [self hotspotACoordinate].x, [self hotspotACoordinate].y);
    NSLog(@"coord B: (%.1f,%.1f)", [self hotspotBCoordinate].x, [self hotspotBCoordinate].y);
    NSLog(@"hashtag A: %@", [self hotspotAHashtag]);
    NSLog(@"hashtag B: %@", [self hotspotBHashtag]);
    NSLog(@"layout: %i", [self imageLayout]);
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

@end
