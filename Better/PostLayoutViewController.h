//
//  PostLayoutViewController.h
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "UserInfo.h"
#import "BELabel.h"

@interface PostLayoutViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

// Outlets to the post's two potential images (here as "A" and "B"), which
// are within UIScrollViews
@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer; // Container that holds scrollViewA and B
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewA;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewB;

// Outlets to control the constraints of the two ScrollViews
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewABottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewATrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBTop;

// Outlets to the "(+)" icons
@property (weak, nonatomic) IBOutlet UIImageView *plusIconA;
@property (weak, nonatomic) IBOutlet UIImageView *plusIconB;

// Outlets to the three layout buttons (single, left-right, top-bottom)
@property (weak, nonatomic) IBOutlet UIButton *layoutButtonSingle;
@property (weak, nonatomic) IBOutlet UIButton *layoutButtonLeftRight;
@property (weak, nonatomic) IBOutlet UIButton *layoutButtonTopBottom;

// Outlet to the hotspot directions label ("Drag spotlights...")
@property (weak, nonatomic) IBOutlet BELabel *hotspotDirectionsLabel;

// Called when back arrow is pressed
- (IBAction)pressedBackArrow:(id)sender;

// Called when Next button is pressed
- (IBAction)pressedNextButton:(id)sender;

// Called when the layout buttons are pressed
- (IBAction)pressedAOnlyLayoutButton:(id)sender;
- (IBAction)pressedLeftRightLayoutButton:(id)sender;
- (IBAction)pressedTopBottomLayoutButton:(id)sender;

@end
