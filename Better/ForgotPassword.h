//
//  ForgotPassword.h
//  Better
//
//  Created by Peter on 5/20/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETextField.h"
#import "BEScrollingViewController.h"

@interface ForgotPassword : BEScrollingViewController <UITextFieldDelegate>

// Text field which holds the email to submit
@property (weak, nonatomic) IBOutlet BETextField *emailTextField;

// Called when 'Submit' is pressed
- (IBAction)submitForgotPassword:(id)sender;

// Returns TRUE if the given email is a valid email; otherwise return FALSE
- (BOOL)validateEmail:(NSString *)email;

// Calls resignFirstResponder on the text field
- (void)dismissKeyboard;

@end
