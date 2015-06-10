//
//  Intro.h
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "IntroPageContent.h"
#import "IntroPage.h"
#import "AppDelegate.h"

// This class is the delegate and DataSource of its UIPageViewController child, which is inside a storyboard Container View
@interface Intro : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

// Outlets for each of the UI elements in the introduction, so we can fade them in and out.
@property (weak, nonatomic) IBOutlet UIImageView *logo; // The Better logo
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage; // The image that changes as the user pages around the PageViewController
@property (weak, nonatomic) IBOutlet UIView *pageViewContainer; // The UIView that serves as the container for the UIPageViewController
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton; // The Getting Started button

// Creates an IntroPage instance (a subclass of UIViewController) given an IntroPageContent object
// which contains the three lines of text and a boolean which specifies whether the first line is a title or not
- (IntroPage *)generatePageWithPageContent:(IntroPageContent *)pageContent;

@end
