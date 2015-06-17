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
- (instancetype)initWithMyVotes:(NSNumber *)myVotes myPosts:(NSNumber *)myPosts favoritePosts:(NSNumber *)favoritePosts favoriteTags:(NSNumber *)favoriteTags following:(NSNumber *)following followers:(NSNumber *)followers
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
