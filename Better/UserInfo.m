//
//  UserInfo.m
//  Better
//
//  Created by Peter on 6/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize username;
@synthesize email;
@synthesize profileImage;
@synthesize gender;
@synthesize birthday;
@synthesize country;

@synthesize uri;
@synthesize img_uri;
@synthesize apiKey;


// Initialize and/or return the user singleton
+ (UserInfo *)user
{
	static UserInfo *user = nil;
	
	@synchronized(self)
	{
		if(!user)
		{
			user = [[UserInfo alloc] init];
		}
	}
	
	return user;
}


//initialize user
- (id)init {
    
    self = [super init];
    
    if(self){
        
        //Server request paths
        uri = @"http://52.0.107.49/v1/";
        img_uri = @"https://52.0.107.49/user_profile_images/";
        apiKey = @"better";
        
        
        //initialize user profile info
        username = @"";
        email = @"";
        profileImage = nil;
    }
    
    return self;
    
}

- (int)getAge
{
	// Create NSDateFormatter to convert string into an NSDate
	NSDateFormatter *strToDate = [[NSDateFormatter alloc] init];
	[strToDate setDateFormat:@"yyyy-MM-dd"];
	
	// Initialize the dates to subtract
	NSDate *now = [NSDate date];
	NSDate *birthdate = [strToDate dateFromString:[self birthday]];
	
	// calculate the age
	if(birthdate == nil)
		return -1;
	else
	{
		// From here:
		// http://stackoverflow.com/questions/5562594/difference-between-two-nsdate-objects-result-also-a-nsdate
		//
		NSCalendar *thisCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *difference = [thisCalendar components:NSYearCalendarUnit
													   fromDate:birthdate
														 toDate:now
														options:0];
		
		return (int)[difference year];
	}
}

- (NSString *)getCountry
{
	// Loop through countries.plist and get the shortname of the given country
	NSDictionary *plistContents = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Countries" ofType:@"plist"]];
	for(NSDictionary *countryDict in [plistContents objectForKey:@"Countries"])
	{
		NSString *countryNameInPlist = [[countryDict objectForKey:@"name"] uppercaseString];
		NSString *countryNameFromAPI = [[self country] objectForKey:@"name"];
		
		if([countryNameInPlist isEqualToString:countryNameFromAPI])
			return [countryDict objectForKey:@"shortname"];
	}
	
	return @"";
}

// Showing/hiding network activity indicator
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
	// Acts kind of like a retain count--multiple objects can ask for the network indicator to turn on
	// and turn off. When the variable is greater than zero, the indicator will be on, and when it gets back
	// to zero, it turns off
	static int numTimesRequestedVisible = 0;
	
	if(visible)
		numTimesRequestedVisible++;
	else if(numTimesRequestedVisible > 0) // Only decrement if it's above zero still
		numTimesRequestedVisible--;
	
	// Debugging
	if(numTimesRequestedVisible < 0)
		NSLog(@"Network activity indicator index below zero: %i", numTimesRequestedVisible);
	
	// Set status of the indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(numTimesRequestedVisible > 0)];
}

@end
