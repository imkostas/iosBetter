//
//  LeaderboardData.h
//  Better
//
//  Created by Peter on 6/23/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaderboardData : NSObject

// Arrays of NSDictionaries to hold rank/leaderboard data.
// Each NSDictionary
@property (strong, nonatomic) NSArray *daily;
@property (strong, nonatomic) NSArray *weekly;
@property (strong, nonatomic) NSArray *allTime;

// Custom initialize
- (instancetype)initWithDailyData:(NSArray *)dailyArray weeklyData:(NSArray *)weeklyArray allTimeData:(NSArray *)allTimeArray;

// no:
// Call this to download rank data from the API given a `limit` variable--this gets rid of previous data
// once the download is finished
//- (void)downloadWithLimit:(NSUInteger)limit;

@end
