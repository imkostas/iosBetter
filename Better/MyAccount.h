//
//  MyAccount.h
//  Better
//
//  Created by Peter on 6/10/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "BEScrollingViewController.h"
#import "BETextField.h"
#import "BEDatePickerView.h"
#import "BEPickerView.h"

@interface MyAccount : BEScrollingViewController <UITextFieldDelegate, BEDatePickerViewDelegate, BEPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

// Outlets for UI elements in My Account screen
@property (weak, nonatomic) IBOutlet UIImageView *profileImageBackground;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet BETextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet BETextField *dobField;
@property (weak, nonatomic) IBOutlet BETextField *countryField;

// Pickers and constraints for birthday field and country field
@property (strong, nonatomic) BEDatePickerView *datePickerView;
@property (strong, nonatomic) NSArray *datePickerViewConstraints;

@property (strong, nonatomic) BEPickerView *regularPickerView;
@property (strong, nonatomic) NSArray *regularPickerViewConstraints;

// List of countries (from Countries.plist)
@property (strong, nonatomic) NSArray *countriesArray;

// Called when the female/male buttons are pressed
- (IBAction)updateFemaleState:(id)sender;
- (IBAction)updateMaleState:(id)sender;

// Called when user taps on profile photo
- (IBAction)takePhoto:(id)sender;

// Called by Update My Account button
- (IBAction)updateAccount:(id)sender;

@end
