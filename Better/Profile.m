//
//  NewAccount.m
//  Better
//
//  Created by Peter on 5/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "Profile.h"

@interface Profile ()
{
	// Holds the offset of the USERNAME text field within the ScrollView for determining how 'faded-in' the
	// ScrollView's background color UIView should be
//	int firstTextFieldOffsetFromTop;
	
	// Keeps track of whether the password should be shown or not shown
	BOOL isPasswordVisible;
	
	// Keeps track of gender;
	// constants are in Definitions.h
	unsigned char gender;
}

// Called once during -viewDidLoad to set up the outer constraints for BEDatePickerView
- (void)setUpDatePickerConstraints;

// Called once during -viewDidLoad to set up the outer constraints for BEPickerView
- (void)setUpRegularPickerConstraints;

// Used to present a date picker with a certain tag
- (void)presentDatePickerWithTag:(NSInteger)tag;

// Presents a regular picker with a tag
- (void)presentRegularPickerWithTag:(NSInteger)tag;

@end

@implementation Profile

#pragma mark - ViewController management

// Setup of this view
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Set color and alpha of the ScrollView background UIView
	//	[[self scrollViewBackground] setAlpha:0.0];
	//	[[self scrollViewBackground] setBackgroundColor:COLOR_BETTER_DARK];
	
	// Set up the navigation bar
//	[[[self navigationController] navigationBar] setBarTintColor:COLOR_BETTER_DARK];
//	[[[self navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
//	[[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	// Initialize variables
	isPasswordVisible = NO;
	gender = GENDER_UNDEFINED;
	
	// Set rank text
	[[self rankLabel] setText:@"NEWBIE"];
	
	// Set profile picture to camera icon ("take picture")
	[[self profileImage] setImage:[UIImage imageNamed:ICON_TAKEPICTURE]];
	[[self profileImageBackground] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PANEL]];
	
	// Set up each of the text field icons
	[[self usernameField] setLeftViewToImageNamed:ICON_ACCOUNT];
	[[self passwordField] setLeftViewToImageNamed:ICON_HTTPS];
	[[self passwordField] setRightViewToImageNamed:ICON_VISIBILITY_OFF];
	[[self emailField] setLeftViewToImageNamed:ICON_EMAIL];
	[[self dobField] setLeftViewToImageNamed:ICON_EVENT];
	[[self countryField] setLeftViewToImageNamed:ICON_FLAG];
	
	// Set up DatePicker
	[self setDatePickerView:[[BEDatePickerView alloc] init]];
	[[self datePickerView] setDelegate:self];
	[self setUpDatePickerConstraints];
	
	// Set up PickerView
	[self setRegularPickerView:[[BEPickerView alloc] init]];
	[[self regularPickerView] setDelegate:self];
	[[[self regularPickerView] picker] setDelegate:self];
	[[[self regularPickerView] picker] setDataSource:self];
	[self setUpRegularPickerConstraints];
	
	// Populate the list of countries
	NSDictionary *plistContents = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]];
	NSMutableArray *countryNames = [[NSMutableArray alloc] init];
	
	// Loop through the dictionaries and grab the regular 'long' names
	for(NSDictionary *country in [plistContents objectForKey:@"Countries"])
		[countryNames addObject:[country objectForKey:@"name"]];
	
	[self setCountriesArray:[countryNames copy]];
	
	// Make the password's right icon tappable---
	// At least for now, it's not necessary to keep a reference to the recognizer in this class, because the UIImageView that it is
	// added to, 'retains' it
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateVisibility:)];
	[[[self passwordField] rightView] setUserInteractionEnabled:YES];  // By default, UIImageViews have userInteractionEnabled == FALSE
	[[[self passwordField] rightView] addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Figure out what the first text field's offset from the top of the scrollview is, now that the view
	// has laid out its subviews
//	firstTextFieldOffsetFromTop = [[self usernameField] frame].origin.y;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	// Get rid of pickers
	[[self datePickerView] dismiss];
	[[self regularPickerView] dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker constraints setup
// Creates constraints for the date picker view
- (void)setUpDatePickerConstraints
{
	// Create constraints for date picker
	NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:[self datePickerView]
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:[self view]
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1
																		  constant:0];
	NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:[self datePickerView]
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self view]
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1
																		   constant:0];
	NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:[self topLayoutGuide]
																	 attribute:NSLayoutAttributeTop
																	 relatedBy:NSLayoutRelationEqual
																		toItem:[self datePickerView]
																	 attribute:NSLayoutAttributeTop
																	multiplier:1
																	  constant:0];
	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:[self bottomLayoutGuide]
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self datePickerView]
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1
																		 constant:0];
	
	[self setDatePickerViewConstraints:[NSArray arrayWithObjects:leadingConstraint, trailingConstraint, bottomConstraint, topConstraint, nil]];
}

// Creates constraints for the country picker view
- (void)setUpRegularPickerConstraints
{
	// Create constraints
	NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:[self regularPickerView]
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:[self view]
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1
																		  constant:0];
	NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:[self regularPickerView]
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:[self view]
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1
																		   constant:0];
	NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:[self topLayoutGuide]
																	 attribute:NSLayoutAttributeTop
																	 relatedBy:NSLayoutRelationEqual
																		toItem:[self regularPickerView]
																	 attribute:NSLayoutAttributeTop
																	multiplier:1
																	  constant:0];
	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:[self bottomLayoutGuide]
																		attribute:NSLayoutAttributeTop
																		relatedBy:NSLayoutRelationEqual
																		   toItem:[self regularPickerView]
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1
																		 constant:0];
	
	
	[self setRegularPickerConstraints:[NSArray arrayWithObjects:leadingConstraint, trailingConstraint, bottomConstraint, topConstraint, nil]];
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

#pragma mark - Profile actions

- (IBAction)createAccount:(id)sender
{
	// Test out weak reference in BETextField
//	UIView *v = [[UIView alloc] initWithFrame:[[[self usernameField] leftView] frame]];
//	[v setBackgroundColor:[UIColor redColor]];
//	[[self usernameField] setLeftView:v];
//	NSLog(@"%@", [[self usernameField] leftImageView]);
}

- (IBAction)takePhoto:(id)sender
{
	NSLog(@"should take picture");
}

// Called when Female button is pressed
- (IBAction)updateFemaleState:(id)sender
{
	if(gender == GENDER_MALE || gender == GENDER_UNDEFINED)
	{
		// 'Color-in' the female button, un-color the male button
		[[self femaleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_FEMALE_PRESSED] forState:UIControlStateNormal];
		[[self maleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_MALE] forState:UIControlStateNormal];
		gender = GENDER_FEMALE;
	}
}

// Called when Male button is pressed
- (IBAction)updateMaleState:(id)sender
{
	if(gender == GENDER_FEMALE || gender == GENDER_UNDEFINED)
	{
		// 'Color-in' the male button, un-color the female button
		[[self femaleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_FEMALE] forState:UIControlStateNormal];
		[[self maleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_MALE_PRESSED] forState:UIControlStateNormal];
		gender = GENDER_MALE;
	}

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

#pragma mark - Controlling the UI
- (void)dismissKeyboard
{
	[[self usernameField] resignFirstResponder];
	[[self passwordField] resignFirstResponder];
	[[self emailField] resignFirstResponder];
}

#pragma mark - UITextField delegate methods
// Called when the keyboard's Return/Next/Done button is pressed while editing a text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// Switch textfields depending on which one is active
	
	if(textField == [self usernameField])
		[[self passwordField] becomeFirstResponder]; // move to the password field
	else if(textField == [self passwordField])
		[[self emailField] becomeFirstResponder]; // move to the email field
	else if(textField == [self emailField])
		[self dismissKeyboard]; // make the keyboard go away
	
	return YES;
}

// Called when the user wants to start typing within a TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	// Allow editing for username, password, and email, but return NO for date-of-birth and country fields,
	// so we can show the date picker and country picker instead
	
	if(textField == [self dobField]) // date-of-birth field
	{
		// Hide keyboard
		[self dismissKeyboard];
		
		// Show a date picker for this particular field
		[self presentDatePickerWithTag:TAG_DATEPICKER_DOB];
		
		return NO;
	}
	else if(textField == [self countryField]) // Country field was selected
	{
		// Hide keyboard
		[self dismissKeyboard];
		
		// Show the country picker
		[self presentRegularPickerWithTag:TAG_PICKER_COUNTRY];
		
		return NO;
	}
	
	return YES;
}

#pragma mark - BEDatePickerView methods
- (void)datePickerWillDismiss:(BEDatePickerView *)datePickerView
{
	// Perform different actions based on which UI element triggered the date picker
	switch([datePickerView tag])
	{
		case TAG_DATEPICKER_DOB:
		{
			NSString *dateString = [NSDateFormatter localizedStringFromDate:[[datePickerView picker] date]
																  dateStyle:NSDateFormatterMediumStyle
																  timeStyle:NSDateFormatterNoStyle];
			[[self dobField] setText:dateString];
			break;
		}
		default:
			break;
	}
}

- (void)datePickerValueChanged:(BEDatePickerView *)datePickerView
{
	// Perform different actions based on which UI element triggered the date picker
	switch([datePickerView tag])
	{
		case TAG_DATEPICKER_DOB:
		{
//			NSString *dateString = [NSDateFormatter localizedStringFromDate:[datePickerView date]
//																  dateStyle:NSDateFormatterMediumStyle
//																  timeStyle:NSDateFormatterNoStyle];
//			[[self dobField] setText:dateString];
			break;
		}
		default:
			break;
	}
}

#pragma mark - Presenting pickers
// Show the date picker
- (void)presentDatePickerWithTag:(NSInteger)tag
{
	// Add if-else statements here to perform certain actions before the picker is shown.
	
	// If setting the birthday, we would like to filter out dates that are in the future
	if(tag == TAG_DATEPICKER_DOB)
	{
		[[[self datePickerView] picker] setMaximumDate:[NSDate date]];
		[[[self datePickerView] label] setText:@"Select your birthday"];
	}
//	else
//		[[[self datePickerView] datePicker] setMaximumDate:nil];
	
	[[self datePickerView] setTag:tag];
	[[self view] addSubview:[self datePickerView]];
	[[self view] addConstraints:[self datePickerViewConstraints]];
	[[self view] layoutIfNeeded];
	[[self datePickerView] show];
}

// Show the regulat picker
- (void)presentRegularPickerWithTag:(NSInteger)tag
{
	// Add if-else statements here to perform certain actions before the picker is shown.
	if(tag == TAG_PICKER_COUNTRY)
	{
		[[[self regularPickerView] label] setText:@"Select your country"];
	}
	
	[[[self regularPickerView] picker] setTag:tag]; // Keep setTag: *before* addSubview:, etc..
	[[self view] addSubview:[self regularPickerView]];
	[[self view] addConstraints:[self regularPickerConstraints]];
	[[self view] layoutIfNeeded];
	[[self regularPickerView] show];
}


#pragma mark - UIPickerView datasource
// How many 'columns' there are in the picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
//	NSLog(@"hello, tag is %i", [pickerView tag]);
	switch([picker tag])
	{
		case TAG_PICKER_COUNTRY:
		{
			return 1;
		}
		default:
			return 0;
	}
}

// Number of rows in a given component (column)
- (NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
	switch([picker tag])
	{
		case TAG_PICKER_COUNTRY:
		{
			return [[self countriesArray] count]; // # of countries
		}
		default:
			return 0;
	}
}

#pragma mark - UIPickerView delegate
// Provides a string for each row of the picker
- (NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch([picker tag])
	{
		case TAG_PICKER_COUNTRY:
		{
			NSString *countryName = [[self countriesArray] objectAtIndex:row];
			return countryName;
		}
		default:
			return nil;
	}
}

//- (void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//	switch([picker tag])
//	{
//		case TAG_PICKER_COUNTRY:
//		{
//			//NSLog(@"country picker selected index: %i", row);
//		}
//		default:
//			break;
//	}
//}

#pragma mark - BEPickerView delegate method
- (void)pickerViewWillDismiss:(BEPickerView *)pickerView
{
	switch([[pickerView picker] tag])
	{
		case TAG_PICKER_COUNTRY:
		{
			// Get the currently-selected index of the first/only column
			NSInteger selectedCountryIndex = [[pickerView picker] selectedRowInComponent:0];
			
			NSString *selectedCountryName = [[self countriesArray] objectAtIndex:selectedCountryIndex];
			[[self countryField] setText:selectedCountryName];
			break;
		}
		default:
			break;
	}
}

//#pragma mark - UIScrollView delegate methods
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//	// Get the current scroll position
//	float position = [scrollView contentOffset].y;
//	
//	if(position >= 0 && position <= firstTextFieldOffsetFromTop)
//	{
////		float newAlpha = position / firstTextFieldOffsetFromTop; // linear
//		float newAlpha = sinf((2 * M_PI)/(4 * firstTextFieldOffsetFromTop) * position); // 1/4 of the first period of a sine wave
//		
//		// Set the alpha of the background view
//		[[self scrollViewBackground] setAlpha:newAlpha];
//	}
//	else if(position < 0)
//		[[self scrollViewBackground] setAlpha:0];
//}

@end
