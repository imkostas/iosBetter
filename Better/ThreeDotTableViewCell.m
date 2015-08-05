//
//  ThreeDotTableViewCell.m
//  Better
//
//  Created by Peter on 8/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotTableViewCell.h"

@implementation ThreeDotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // Programmatic initialization code
        [[self textLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:15.0]];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code (only for nib loading) -- doesn't get called when you use -registerClass:...
    [[self textLabel] setFont:[UIFont fontWithName:FONT_RALEWAY_MEDIUM size:15.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
