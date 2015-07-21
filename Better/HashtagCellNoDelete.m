//
//  HashtagCellNoDelete.m
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "HashtagCellNoDelete.h"

@implementation HashtagCellNoDelete

- (void)awakeFromNib
{
    // Initialization code
    [[self hashtagLabel] setText:@"#hi"];
}

- (CGSize)intrinsicContentSize
{
    return [[self hashtagLabel] intrinsicContentSize];
}

@end
