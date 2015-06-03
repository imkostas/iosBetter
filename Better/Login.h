//
//  Login.h
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVController.h"
#import "UserInfo.h"
#import "BETextField.h"
#import "BEScrollingViewController.h"
#import "Definitions.h"

@interface Login : BEScrollingViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BETextField *usernameField;
@property (weak, nonatomic) IBOutlet BETextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

// Reference to UserInfo object
@property (weak, nonatomic) UserInfo *user;

// Called when the 'Log In' button is pressed
- (IBAction)logIn:(id)sender;
// Called when 'Log in with Facebook' is pressed
- (IBAction)logInFacebook:(id)sender;

// Returns TRUE if the given username and password are valid (i.e. their lengths
// are not zero) and FALSE otherwise
- (BOOL)validateUsername:(NSString *)user password:(NSString *)pass;

// Called when the user presses on the password field's visibility area
- (void)updateVisibility:(UITapGestureRecognizer *)recognizer;

// Dismiss keyboard
- (void)dismissKeyboard;

@end
