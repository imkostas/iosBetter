//
//  UserCounts.m
//  Better
//
//  Created by Peter on 6/16/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "UserCounts.h"

@implementation UserCounts

// Custom init
- (instancetype)initWithMyVotes:(NSString *)myVotes myPosts:(NSString *)myPosts favoritePosts:(NSString *)favoritePosts favoriteTags:(NSString *)favoriteTags following:(NSString *)following followers:(NSString *)followers
{
	self = [super init];
	if(self)
	{
		_myVotes = myVotes;
		_myPosts = myPosts;
		_favoritePosts = favoritePosts;
		_favoriteTags = favoriteTags;
		_following = following;
		_followers = followers;
	}
	
	return self;
}

@end
