//
//  PostLayoutViewController.h
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface PostLayoutViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

// Outlets to the post's two potential images (here as "A" and "B"), which
// are within UIScrollViews
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewA;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewB;

// Outlets to control the constraints of the two ScrollViews
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewABottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewATrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBTop;

// Called when back arrow is pressed
- (IBAction)pressedBackArrow:(id)sender;

// Called when Next button is pressed
- (IBAction)pressedNextButton:(id)sender;

@end
