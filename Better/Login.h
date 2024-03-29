//
//  Login.h
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>

#import "Feed.h"
#import "UserInfo.h"
#import "BETextField.h"
#import "BEScrollingViewController.h"

@interface Login : BEScrollingViewController <UITextFieldDelegate, CustomAlertDelegate>

@property (weak, nonatomic) IBOutlet BETextField *usernameField;
@property (weak, nonatomic) IBOutlet BETextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;


@property (nonatomic, strong) CustomAlert *customAlert; //custom alert
// Reference to UserInfo object
@property (weak, nonatomic) UserInfo *user;

// Called when the 'Log In' button is pressed
- (IBAction)logIn:(id)sender;
// Called when 'Log in with Facebook' is pressed
- (IBAction)logInFacebook:(id)sender;

// Called when the usernameField's text changes
- (IBAction)usernameTextChanged:(id)sender;

// Returns TRUE if the given username and password are valid (i.e. their lengths
// are not zero) and FALSE otherwise
- (BOOL)validateUsername:(NSString *)user password:(NSString *)pass;

// Called when the user presses on the password field's visibility area
- (void)updateVisibility:(UITapGestureRecognizer *)recognizer;

// Dismiss keyboard
- (void)dismissKeyboard;

@end
