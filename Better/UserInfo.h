//
//  UserInfo.h
//  Better
//
//  Created by Peter on 6/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Definitions.h"
#import "CustomAlert.h"
#import "UserRank.h"
#import "UserNotifications.h"
#import "UserCounts.h"
#import "LeaderboardData.h"

@interface UserInfo : NSObject

// Account information
@property (strong, nonatomic)	NSString *username;
@property (nonatomic)			int userID;
@property (nonatomic)			long facebookID;
@property (strong, nonatomic)	NSString *email;
@property (strong, nonatomic)	UIImage *profileImage;
@property (nonatomic)			unsigned char gender;
@property (strong, nonatomic)	NSString *birthday;
@property (strong, nonatomic)	NSDictionary *country; // contains an 'id' key and a 'name' key
@property (strong, nonatomic)	UserRank *rank;
@property (strong, nonatomic)	UserNotifications *notification;
@property (strong, nonatomic)	UserCounts *counts;
@property (strong, nonatomic)	LeaderboardData *leaderboardData;

// State of the user
@property (nonatomic, getter=isLoggedIn) BOOL loggedIn;

//global back-end paths
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *img_uri;
@property (nonatomic, strong) NSString *apiKey;

// Keychain service name
@property (strong, nonatomic) NSString *keychainServiceName;

// Initialize and/or return the user singleton
+ (UserInfo *)user;

// Return information in readable formats (used in MyInformation)
- (int)getAge;
- (NSString *)getCountry;

// Handles requests to show or hide the network activity indicator
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible;

// Called by classes which perform the login -- they provide the responseObject from an AFNetworking request
- (BOOL)populateUserInfoWithResponseObject:(id)responseObject;

@end
