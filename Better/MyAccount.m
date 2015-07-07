//
//  MyAccount.m
//  Better
//
//  Created by Peter on 6/10/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "MyAccount.h"

@interface MyAccount ()
{
	// Keeps track of gender
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

#pragma mark - ViewController management
@implementation MyAccount

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Check for profile image
	if([[UserInfo user] profileImage] == nil)
	{
		[[self profileImage] setImage:[UIImage imageNamed:ICON_TAKEPICTURE]];
		[[self profileImageBackground] setImage:[UIImage imageNamed:IMAGE_EMPTY_PROFILE_PANEL]];
	}
	
	// Get the list of countries from Countries.plist
	NSDictionary *plistContents = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]];
	NSMutableArray *countryNames = [[NSMutableArray alloc] init];
	
	// Loop through the dictionaries and grab the regular 'long' names
	for(NSDictionary *country in [plistContents objectForKey:@"Countries"])
		[countryNames addObject:[country objectForKey:@"name"]];
	
	[self setCountriesArray:[countryNames copy]];
	
	// Set up the TextFields
	[[self usernameField] setLeftViewToImageNamed:ICON_ACCOUNT];
	[[self dobField] setLeftViewToImageNamed:ICON_EVENT];
	[[self countryField] setLeftViewToImageNamed:ICON_FLAG];

	// Populate the profile information from UserInfo:
	
	[[self usernameField] setText:[[UserInfo user] username]];
	
	// Birthday
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter dateFromString:[[UserInfo user] birthday]];
	[[self dobField] setText:[[UserInfo user] birthday]];
	unsigned int countryID = [[[[UserInfo user] country] objectForKey:@"id"] intValue];
	
	// Make sure the given country ID is within the bounds of the array in Countries.plist
	if(countryID > 0 && countryID < [[self countriesArray] count]) // Valid id (index)
		[[self countryField] setText:[[self countriesArray] objectAtIndex:countryID]];
	else // ID is not valid, so just display the name
		[[self countryField] setText:[[[UserInfo user] country] objectForKey:@"name"]];
	
	// Set gender, 'color-in' the corresponding button
	gender = [[UserInfo user] gender];
	if(gender == GENDER_FEMALE)
		[[self femaleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_FEMALE_PRESSED] forState:UIControlStateNormal];
	else if(gender == GENDER_MALE)
		[[self maleButton] setImage:[UIImage imageNamed:IMAGE_GENDER_MALE_PRESSED] forState:UIControlStateNormal];
	
	// Set up the pickers:
	// DatePicker
	[self setDatePickerView:[[BEDatePickerView alloc] init]];
	[[self datePickerView] setDelegate:self];
	[self setUpDatePickerConstraints];
	
	// Regular picker (UIPickerView)
	[self setRegularPickerView:[[BEPickerView alloc] init]];
	[[self regularPickerView] setDelegate:self];
	[[[self regularPickerView] picker] setDelegate:self];
	[[[self regularPickerView] picker] setDataSource:self];
	[self setUpRegularPickerConstraints];
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
	
	
	[self setRegularPickerViewConstraints:[NSArray arrayWithObjects:leadingConstraint, trailingConstraint, bottomConstraint, topConstraint, nil]];
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
// Called when female button is pressed
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

// Called when male button is pressed
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

// Called from pressing on profile photo
- (IBAction)takePhoto:(id)sender
{
	NSLog(@"My Account - pick a photo");
}

- (IBAction)updateAccount:(id)sender
{
	NSLog(@"My Account - update my account");
}

#pragma mark - UITextField delegate methods
// Called when the user wants to start typing within a TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	// Return NO for username, date-of-birth and country fields,
	// so we can show the date picker and country picker instead
	
	if(textField == [self dobField]) // date-of-birth field
		// Show a date picker for this particular field
		[self presentDatePickerWithTag:TAG_DATEPICKER_DOB];
	
	else if(textField == [self countryField]) // Country field was selected
		// Show the country picker
		[self presentRegularPickerWithTag:TAG_PICKER_COUNTRY];
	
	// There are no textfields that are able to be edited with the keyboard
	return NO;
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
			// Maybe set the date again(?)
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
		// Get the current birthdate and set the picker accordingly
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"]; // Format returned by API
		NSDate *currentBirthday = [dateFormatter dateFromString:[[UserInfo user] birthday]];
		if(currentBirthday != nil)
			[[[self datePickerView] picker] setDate:currentBirthday animated:NO];
		
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
	[[self view] addConstraints:[self regularPickerViewConstraints]];
	[[self view] layoutIfNeeded];
	[[self regularPickerView] show];
}

#pragma mark - UIPickerView datasource
// How many 'columns' there are in the picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
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
		}
		default:
			break;
	}
}

@end
