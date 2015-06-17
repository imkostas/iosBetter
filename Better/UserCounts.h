//
//  UserCounts.h
//  Better
//
//  Created by Peter on 6/16/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCounts : NSObject

// Variables for the user's counts
@property (nonatomic) NSNumber *myVotes;
@property (nonatomic) NSNumber *myPosts;
@property (nonatomic) NSNumber *favoritePosts;
@property (nonatomic) NSNumber *favoriteTags;
@property (nonatomic) NSNumber *following;
@property (nonatomic) NSNumber *followers;

// Custom init
- (instancetype)initWithMyVotes:(NSNumber *)myVotes myPosts:(NSNumber *)myPosts favoritePosts:(NSNumber *)favoritePosts favoriteTags:(NSNumber *)favoriteTags following:(NSNumber *)following followers:(NSNumber *)followers;

@end
