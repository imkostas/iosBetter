//
//  LeaderboardTableViewCell.m
//  Better
//
//  Created by Peter on 6/23/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "LeaderboardTableViewCell.h"

@implementation LeaderboardTableViewCell

- (void)awakeFromNib
{
    // Initialization code
	
	// Set the background color
	[self setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
