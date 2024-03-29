//
//  Intro.h
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <SSKeychain/SSKeychain.h>

#import "Definitions.h"
#import "UserInfo.h"
#import "IntroPageContent.h"
#import "IntroPage.h"
#import "Feed.h"

// This class is the delegate and DataSource of its UIPageViewController child, which is inside a storyboard Container View
@interface Intro : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>

// Outlets for each of the UI elements in the introduction, so we can fade them in and out.
@property (weak, nonatomic) IBOutlet UIImageView *logo; // The Better logo
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage; // The image that changes as the user pages around the PageViewController
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton; // The Getting Started button

// Reference to the UserInfo shared object
@property (weak, nonatomic) UserInfo *user;

// A reference to the UIPageControl embedded inside the UIPageViewController
//@property (weak, nonatomic) UIPageControl *pageControl;

// Called by `pageControl` when its value is changed
//- (void)pageControlValueChanged:(UIPageControl *)sender;

// Creates an IntroPage instance (a subclass of UIViewController) given an IntroPageContent object
// which contains the three lines of text and a boolean which specifies whether the first line is a title or not
- (IntroPage *)generatePageWithPageContent:(IntroPageContent *)pageContent;

// Method that is called by the unwind segue linked to the Log Out button
- (IBAction)unwindToIntro:(UIStoryboardSegue *)sender;

@end
