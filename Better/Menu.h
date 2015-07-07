//
//  MenuViewController.h
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETappableView.h"
#import "UserInfo.h"

@interface MenuViewController : UIViewController <BETappableViewDelegate>

// The UIScrollView that contains all UI elements of the Menu
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Profile image and username label are contained within the profileView UIView
@property (weak, nonatomic) IBOutlet BETappableView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePanelView;
@property (weak, nonatomic) IBOutlet UIView *profilePanelViewOverlay;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

// My Ranking and Settings are made up of an icon (UIImageView) and a UILabel
// within an outer UIView. The outer UIView has a tap gesture recognizer on it.
@property (weak, nonatomic) IBOutlet BETappableView *myRankingView;
@property (weak, nonatomic) IBOutlet BETappableView *settingsView;

@end
