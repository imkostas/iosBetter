//
//  NewAccount.h
//  Better
//
//  Created by Peter on 5/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "BEScrollingViewController.h"
#import "BETextField.h"
#import "BEDatePickerView.h"
#import "BEPickerView.h"

@interface Profile : BEScrollingViewController <UIScrollViewDelegate, UITextFieldDelegate, BEDatePickerViewDelegate, BEPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageBackground; // background of profile image
@property (weak, nonatomic) IBOutlet UIImageView *profileImage; // profile image itself
@property (weak, nonatomic) IBOutlet UILabel *rankLabel; // the rank text

// A UIView that lives on top the profile image, rank, etc. and below the ScrollView; it is used for
// gradually blocking out the profile image area as the user scrolls downward in the ScrollView
@property (weak, nonatomic) IBOutlet UIView *scrollViewBackground;

// UIScrollView is taken care of by superclass (BEScrollingViewController)
// Elements within ScrollView:
@property (weak, nonatomic) IBOutlet BETextField *usernameField;
@property (weak, nonatomic) IBOutlet BETextField *passwordField;
@property (weak, nonatomic) IBOutlet BETextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet BETextField *dobField;
@property (weak, nonatomic) IBOutlet BETextField *countryField;

// UIDatePicker and UIPickerView for birthday field and country selection
@property (strong, nonatomic) BEDatePickerView *datePickerView;
@property (strong, nonatomic) NSArray *datePickerViewConstraints;

@property (strong, nonatomic) BEPickerView *regularPickerView;
@property (strong, nonatomic) NSArray *regularPickerConstraints;

// List of countries (sourced from a .plist)
@property (strong, nonatomic) NSArray *countriesArray;

// Called when 'Create My Account' is pressed
- (IBAction)createAccount:(id)sender;

// Called when the user presses on their profile picture (a separate button that lies within the scroll view, over the profile image)
- (IBAction)takePhoto:(id)sender;

// Called when the female and male buttons are pressed, respectively
- (IBAction)updateFemaleState:(id)sender;
- (IBAction)updateMaleState:(id)sender;

// Called when the user presses on the password field's visibility area
- (void)updateVisibility:(UITapGestureRecognizer *)recognizer;

// Put keyboard down
- (void)dismissKeyboard;

@end
