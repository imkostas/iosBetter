//
//  MyInfoTableViewCell.m
//  Better
//
//  Created by Peter on 6/16/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
// https://medium.com/@musawiralishah/creating-custom-uitableviewcell-using-nib-xib-files-in-xcode-9bee5824e722

#import "MyInfoTableViewCell.h"

@implementation MyInfoTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	
	// Make it's background color light gray for all states
	[self setBackgroundColor:COLOR_LIGHT_LIGHT_GRAY];
}

@end
