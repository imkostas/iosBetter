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
@property (strong, nonatomic)	NSDictionary *notification;

//global back-end paths
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *img_uri;
@property (nonatomic, strong) NSString *apiKey;

// Initialize and/or return the user singleton
+ (UserInfo *)user;

@end
