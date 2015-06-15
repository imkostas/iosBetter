//
//  Rank.m
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "UserRank.h"

@implementation UserRank

// Initialize all the vars
- (instancetype)initWithRank:(int)rank totalPoints:(int)totalPoints dailyPoints:(int)dailyPoints weeklyPoints:(int)weeklyPoints badgeTastemaker:(int)badgeTastemaker badgeAdventurer:(int)badgeAdventurer badgeAdmirer:(int)badgeAdmirer badgeRoleModel:(int)badgeRoleModel badgeCelebrity:(int)badgeCelebrity badgeIdol:(int)badgeIdol
{
	self = [super init];
	if(self)
	{
		_rank = rank;
		_totalPoints = totalPoints;
		_dailyPoints = dailyPoints;
		_weeklyPoints = weeklyPoints;
		_badgeTastemaker = badgeTastemaker;
		_badgeAdventurer = badgeAdventurer;
		_badgeAdmirer = badgeAdmirer;
		_badgeRoleModel = badgeRoleModel;
		_badgeCelebrity = badgeCelebrity;
		_badgeIdol = badgeIdol;
	}
	return self;
}

@end
