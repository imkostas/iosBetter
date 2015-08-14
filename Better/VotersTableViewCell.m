//
//  VotersTableViewCell.m
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "VotersTableViewCell.h"

@implementation VotersTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    // Set up profile picture view layer
    [[[self profilePictureView] layer] setMasksToBounds:YES];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    // Re-size the corner radius as necessary
    [[[self profilePictureView] layer] setCornerRadius:(CGRectGetWidth([[self profilePictureView] bounds]) / 2)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
