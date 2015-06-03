//
//  IntroPage.h
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
// Two view controllers are assigned this class in the storyboard, with storyboard IDs:
// introPageTitle, and introPageNoTitle

#import <UIKit/UIKit.h>

@interface IntroPage : UIViewController

// UILabel IBOutlets for each line of the text of each page
@property (weak, nonatomic) IBOutlet UILabel *textOne;
@property (weak, nonatomic) IBOutlet UILabel *textTwo;
@property (weak, nonatomic) IBOutlet UILabel *textThree;

// Variable to hold this page's background UIImage; this property is read by methods
// inside Intro.m to set the image of a UIImageView. It's not actually visible in this
// view controller
@property (strong, nonatomic) UIImage *image;

@end
