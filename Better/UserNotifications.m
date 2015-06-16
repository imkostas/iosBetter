//
//  UserNotifications.m
//  Better
//
//  Created by Peter on 6/16/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "UserNotifications.h"

@implementation UserNotifications

// Initialize the notification preference values
- (instancetype)initWithVotedPostPref:(int)votedPost favoritedPostPref:(int)favoritedPost newFollowerPref:(int)newFollower
{
	self = [super init];
	if(self)
	{
		_votedPost = votedPost;
		_favoritedPost = favoritedPost;
		_newFollower = newFollower;
	}
	
	return self;
}

@end
