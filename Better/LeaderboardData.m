//
//  LeaderboardData.m
//  Better
//
//  Created by Peter on 6/23/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "LeaderboardData.h"

@implementation LeaderboardData

- (instancetype)initWithDailyData:(NSArray *)dailyArray weeklyData:(NSArray *)weeklyArray allTimeData:(NSArray *)allTimeArray
{
	self = [super init];
	if(self)
	{
		_daily = dailyArray;
		_weekly = weeklyArray;
		_allTime = allTimeArray;
	}
	
	return self;
}

@end
