//
//  Login.m
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Login.h"

@interface Login ()
{
	// Keeps track of whether the password should be shown or not shown
	BOOL isPasswordVisible;
}

@end

@implementation Login

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //initialize user info
    self.user = [UserInfo user];
	
	[[self usernameField] setLeftViewToImageNamed:ICON_ACCOUNT];
	[[self passwordField] setLeftViewToImageNamed:ICON_HTTPS];
	[[self passwordField] setRightViewToImageNamed:ICON_VISIBILITY_OFF];
	
	// Make the password's right icon tappable---
	// At least for now, it's not necessary to keep a reference to the recognizer in this class, because the UIImageView that it is
	// added to, 'retains' it
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateVisibility:)];
	[[[self passwordField] rightView] setUserInteractionEnabled:YES];  // By default, UIImageViews have userInteractionEnabled == FALSE
	[[[self passwordField] rightView] addGestureRecognizer:tapGesture];
	
	// Get the UserInfo object
	[self setUser:[UserInfo user]];
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

#pragma mark - Login, validation
// Called when the 'Log In' button is pressed
- (IBAction)logIn:(id)sender
{
	[self dismissKeyboard];
	
	// Validate the given information
	if([self validateUsername:[[self usernameField] text] password:[[self passwordField] text]])
	{
    
         AFHTTPRequestOperationManager *manager =  [AFHTTPRequestOperationManager manager];
         manager.requestSerializer = [AFJSONRequestSerializer serializer];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];

        
        [manager POST:[NSString stringWithFormat:@"%@user/login", self.user.uri]
         
                    parameters: @{@"api_key":   self.user.apiKey,
                                  @"username":  [[self usernameField] text],
                                  @"password":  [[self passwordField] text]}

              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", [responseObject description]);
                
                  
                  //save user info - username, email, funds
                  self.user.username = [responseObject valueForKey:@"username"];
                  self.user.email = [responseObject valueForKey:@"email"];
                  self.user.gender = [[responseObject valueForKey:@"gender"]charValue];
                  self.user.birthday = [responseObject valueForKey:@"birthday"] ;
                  self.user.country = [responseObject valueForKey:@"country"];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", [error description]);
                  //[self customAlert:@"We were unable to log you in" withDone:@"Ok"];
                  UIAlertView *invalidAlert = [[UIAlertView alloc] initWithTitle:@"Missing username or password"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                  [invalidAlert show];
              }
         ];
		
		NSAssert([self storyboard], @"Tried to instantiate MainViewController without a storyboard...");
		
		UINavigationController *feedVCNavigation = [[self storyboard] instantiateViewControllerWithIdentifier:STORYBOARD_ID_FEED_NAVIGATION];
		[self presentViewController:feedVCNavigation animated:YES completion:nil];
	}
	else
	{
		// Non valid username and/or password
		
		UIAlertView *invalidAlert = [[UIAlertView alloc] initWithTitle:@"Missing username or password"
																	 message:nil
																	delegate:nil
														   cancelButtonTitle:@"OK"
														   otherButtonTitles:nil];
		[invalidAlert show];
	}
}



// Called when 'Log in with Facebook' is pressed
- (IBAction)logInFacebook:(id)sender
{
	[self dismissKeyboard];
	
	NSLog(@"Log in to Facebook was pressed");
}

// Validate username and password
- (BOOL)validateUsername:(NSString *)user password:(NSString *)pass
{
	if([user length] > 0 && [pass length] > 0)
		return TRUE;
	else
		return FALSE;
}

#pragma mark - Gesture recognizer methods

// Called when the visibility area of the password field is pressed
- (void)updateVisibility:(UITapGestureRecognizer *)recognizer
{
	// Change the image and visibility of the password field
	if(isPasswordVisible)
	{
		// Make non-visible
		[[self passwordField] updateRightViewImageToImageNamed:ICON_VISIBILITY_OFF];
		[[self passwordField] setSecureTextEntry:YES];
	}
	else
	{
		// Make visible
		[[self passwordField] updateRightViewImageToImageNamed:ICON_VISIBILITY_ON];
		[[self passwordField] setSecureTextEntry:NO];
	}
	
	isPasswordVisible = !isPasswordVisible;
}

# pragma mark - Controlling the UI
- (void)dismissKeyboard
{
    //dismiss keyboard if active
	[[self usernameField] resignFirstResponder];
	[[self passwordField] resignFirstResponder];
}

// Called when the keyboard's Return/Next/Done button is pressed while editing a text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// If the username field is active right now, move to the password field
	if(textField == [self usernameField])
	   [[self passwordField] becomeFirstResponder];
	else // Just make the keyboard go away
		[self dismissKeyboard];
	
	return YES;
}

#pragma mark - Memory management
- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

//method for creating and presenting a custom alert object
- (void)customAlert:(NSString *)alert withDone:(NSString *)done {
    
    //if alert already showing, hide it
    if(self.customAlert){
        
        //set custom alert alpha to 0
        [UIView animateWithDuration:0.25 animations:^{[self.customAlert setAlpha:0.0f];}];
    }
    
    //initialize custom alert object
    self.customAlert = [[CustomAlert alloc] initWithType:1 withframe:self.view.frame withMessage:alert];
    [self.customAlert.leftButton setTitle:done forState:UIControlStateNormal];
    self.customAlert.customAlertDelegate = self;
    
    //add as subview and make alpha 1.0
    [self.view addSubview:self.customAlert];
    [UIView animateWithDuration:0.25 animations:^{[self.customAlert setAlpha:1.0f];}];
}

//custom alert object left button delegate method
- (void)leftActionMethod:(int)method {
    
    //hide custom alert and remove it from its superview
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.customAlert setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        [self.customAlert removeFromSuperview];
    }];
}

//custom alert object right button delegate method
- (void)rightActionMethod:(int)method {
    
    //nothing for now
}


@end
