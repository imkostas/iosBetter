//
//  UserNotifications.h
//  Better
//
//  Created by Peter on 6/16/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotifications : NSObject

// Vars for push notification preferences
@property (nonatomic) int votedPost;
@property (nonatomic) int favoritedPost;
@property (nonatomic) int newFollower;

// Custom init
- (instancetype)initWithVotedPostPref:(int)votedPost favoritedPostPref:(int)favoritedPost newFollowerPref:(int)newFollower;

@end
