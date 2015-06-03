//
//  ForgotPassword.m
//  Better
//
//  Created by Peter on 5/20/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ForgotPassword.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[[self emailTextField] setLeftViewToImageNamed:ICON_EMAIL];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Email validation, submission

// Called when 'Submit' is pressed
- (IBAction)submitForgotPassword:(id)sender
{
	[[self emailTextField] resignFirstResponder]; // Put down keyboard
	
	BOOL isValid = [self validateEmail:[[self emailTextField] text]]; // Validate email
	
	NSLog(@"Submitting email for reset password, valid: %s", (isValid) ? "yes": "no");
}

// Returns TRUE if the given email is a valid email; otherwise return FALSE
- (BOOL)validateEmail:(NSString *)email
{
	// https://techfuzionwithsam.wordpress.com/2014/01/09/email-address-validation-in-ios/
	//
	NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	
	// Sets up an NSPredicate to validate an email using a regular expression
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegEx];
	BOOL isValid = [emailPredicate evaluateWithObject:email];
	
	return isValid;
}

#pragma mark Handling keyboard/TextField

// Dismiss the keyboard
- (void)dismissKeyboard
{
	[[self emailTextField] resignFirstResponder];
}

// Called when the Return/Done button on the keyboard is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self dismissKeyboard];
	
	return YES;
}

@end
