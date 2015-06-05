//
//  UserInfo.h
//  Better
//
//  Created by Peter on 6/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface UserInfo : NSObject

// Account information
@property (strong, nonatomic)	NSString *username;
@property (strong, nonatomic)	NSString *email;
@property (strong, nonatomic)	UIImage *profileImage;
@property (nonatomic)			char gender;
@property (strong, nonatomic)	NSDate *birthday;
@property (strong, nonatomic)	NSString *country;

// Initialize and/or return the user singleton
+ (UserInfo *)user;

@end
