//
//  BetterViewController.h
//  Better
//
//  Created by Peter on 5/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
// This is a class that reacts to the keyboard showing and hiding by adjusting its scroll view
// so that no UI elements are covered up by the keyboard
//
// All it requires is an IBOutlet to the bottom constraint of the scroll view (but not necessarily
// a scroll view in particular)
// Usually will be seen as this: constraint from Bottom <--> Bottom Layout Guide

#import <UIKit/UIKit.h>

@interface BEScrollingViewController : UIViewController

// the UIView embedded within the UIScrollView, inside of which all the UI elements are
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
// the UIScrollView itself, which is a direct descendant of the outermost UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// The constraint that ties the bottom of the view / scroll view to the bottom of the outermost UIView
// Changing this constraint's 'constant' property to a positive value creates space under the scroll view,
// allowing you to to make room for the keyboard, for example
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintContent;

// Called when the keyboard is about to appear or hide
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
