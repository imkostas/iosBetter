//
//  UserInfo.m
//  Better
//
//  Created by Peter on 6/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

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

@end
