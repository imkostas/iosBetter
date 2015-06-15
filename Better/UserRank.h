//
//  Rank.h
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRank : NSObject

// Places to hold rank data
@property (nonatomic) int rank;
@property (nonatomic) int totalPoints;
@property (nonatomic) int dailyPoints;
@property (nonatomic) int weeklyPoints;
@property (nonatomic) int badgeTastemaker;
@property (nonatomic) int badgeAdventurer;
@property (nonatomic) int badgeAdmirer;
@property (nonatomic) int badgeRoleModel;
@property (nonatomic) int badgeCelebrity;
@property (nonatomic) int badgeIdol;

// Initialize all the vars
- (instancetype)initWithRank:(int)rank totalPoints:(int)totalPoints dailyPoints:(int)dailyPoints weeklyPoints:(int)weeklyPoints badgeTastemaker:(int)badgeTastemaker badgeAdventurer:(int)badgeAdventurer badgeAdmirer:(int)badgeAdmirer badgeRoleModel:(int)badgeRoleModel badgeCelebrity:(int)badgeCelebrity badgeIdol:(int)badgeIdol;

@end
