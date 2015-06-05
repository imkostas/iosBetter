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

@end
