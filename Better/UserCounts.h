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
@property (strong, nonatomic) NSString *myVotes;
@property (strong, nonatomic) NSString *myPosts;
@property (strong, nonatomic) NSString *favoritePosts;
@property (strong, nonatomic) NSString *favoriteTags;
@property (strong, nonatomic) NSString *following;
@property (strong, nonatomic) NSString *followers;

// Custom init
- (instancetype)initWithMyVotes:(NSString *)myVotes myPosts:(NSString *)myPosts favoritePosts:(NSString *)favoritePosts favoriteTags:(NSString *)favoriteTags following:(NSString *)following followers:(NSString *)followers;

@end
