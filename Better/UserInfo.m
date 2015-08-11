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
@synthesize s3_url;

@synthesize loggedIn;
@synthesize keychainServiceNameLogin;


/**
 Initialize and/or return the user singleton
 */
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
        s3_url = @"https://s3.amazonaws.com/better.thememedesign.com/";
        
        // Keychain service name
        keychainServiceNameLogin = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".login"];
        
        //initialize user profile info
        username = @"";
        email = @"";
        profileImage = nil;
        loggedIn = FALSE;
    }
    
    return self;
    
}

#pragma mark - Returning user-readable info
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

#pragma mark - UI control
// Showing/hiding network activity indicator
//- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
//{
//	// Acts kind of like a retain count--multiple objects can ask for the network indicator to turn on
//	// and turn off. When the variable is greater than zero, the indicator will be on, and when it gets back
//	// to zero, it turns off
//	static int numTimesRequestedVisible = 0;
//	
//	if(visible)
//		numTimesRequestedVisible++;
//	else if(numTimesRequestedVisible > 0) // Only decrement if it's above zero still
//		numTimesRequestedVisible--;
//	
//	// Debugging
//	if(numTimesRequestedVisible < 0)
//		NSLog(@"Network activity indicator index below zero: %i", numTimesRequestedVisible);
//	
//	// Set status of the indicator
//    if(numTimesRequestedVisible > 0 && [[UIApplication sharedApplication] isNetworkActivityIndicatorVisible] == NO)
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    else if(numTimesRequestedVisible == 0)
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}

#pragma mark - Data parsing
// Provided a response from the server, this method populates the properties of this UserInfo object with
// the information inside the response
// Returns FALSE if an error occurred when parsing through the response data
- (BOOL)populateUserInfoWithResponseObject:(id)responseObject
{
    // If the data returned from the server is unexpected in any way, there can be exceptions thrown by
    // calling -intValue and -characterAtIndex: for example.
    @try
    {
        //save user info - username, email, funds
        NSDictionary *userDictionary = [[responseObject objectForKey:@"response"] objectForKey:@"user"];
        
        // Retrieve values from the dictionary
        self.userID = [[userDictionary objectForKey:@"id"] intValue];
        self.username = [userDictionary objectForKey:@"username"];
        self.email = [userDictionary objectForKey:@"email"];
        self.gender = [[userDictionary objectForKey:@"gender"] characterAtIndex:0]; // "gender" value is "1" or "2"
        self.birthday = [userDictionary objectForKey:@"birthday"];
        self.country = [userDictionary objectForKey:@"country"];
        
        // Populate rank
        NSDictionary *rankDict = [userDictionary objectForKey:@"rank"];
        UserRank *rank = [[UserRank alloc] initWithRank:[[rankDict objectForKey:@"rank"] intValue]
                                            totalPoints:[[rankDict objectForKey:@"total_points"] intValue]
                                            dailyPoints:[[rankDict objectForKey:@"daily_points"] intValue]
                                           weeklyPoints:[[rankDict objectForKey:@"weekly_points"] intValue]
                                        badgeTastemaker:[[rankDict objectForKey:@"badge_tastemaker"] intValue]
                                        badgeAdventurer:[[rankDict objectForKey:@"badge_adventurer"] intValue]
                                           badgeAdmirer:[[rankDict objectForKey:@"badge_admirer"] intValue]
                                         badgeRoleModel:[[rankDict objectForKey:@"badge_role_model"] intValue]
                                         badgeCelebrity:[[rankDict objectForKey:@"badge_celebrity"] intValue]
                                              badgeIdol:[[rankDict objectForKey:@"badge_idol"] intValue]];
        self.rank = rank;
        
        // Populate notifications preferences
        NSDictionary *notificationsDict = [userDictionary objectForKey:@"notification"];
        UserNotifications *notifs = [[UserNotifications alloc] initWithVotedPostPref:[[notificationsDict objectForKey:@"voted_post"] intValue]
                                                                   favoritedPostPref:[[notificationsDict objectForKey:@"favorited_post"] intValue]
                                                                     newFollowerPref:[[notificationsDict objectForKey:@"new_follower"] intValue]];
        self.notification = notifs;
        
        // Everything's OK
        return TRUE;
    }
    @catch(NSException *exception)
    {
        // Called a unrecognized method on an object (the response does not contain the type of data we expect)
        if([exception isKindOfClass:[NSInvalidArgumentException class]])
        {
            NSLog(@"** EXCEPTION: Unexpected data received from login request! (%@)", [exception name]);
        }
        else
        {
            NSLog(@"** EXCEPTION: Unknown exception occurred! (%@)", [exception name]);
        }
        
        // Error occurred
        return FALSE;
    }
}

@end
