//
//  ThreeDotTableViewCell.m
//  Better
//
//  Created by Peter on 8/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotTableViewCell.h"

#define MARGIN_LEFTRIGHT 16
#define WIDTH_ICON 25

//@interface ThreeDotTableViewCell ()
//{
//    // Only configure constraints once
//    BOOL alreadyConfiguredConstraints;
//}
//
//// Raleway Medium font, size 15
//@property (strong, nonatomic) UIFont *ralewayFont;
//
//@end

@implementation ThreeDotTableViewCell

/*- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // Get the font
        _ralewayFont = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:15.0];
        
        // Set up UI elements
        _label = [[UILabel alloc] init];
        _icon = [[UIImageView alloc] init];
        
        // Configure UI elements
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setFont:_ralewayFont];
        [_icon setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Add them to the contentView
        [[self contentView] addSubview:_label];
        [[self contentView] addSubview:_icon];
    }
    
    return self;
}*/

- (void)awakeFromNib
{
    // Initialization code
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(!alreadyConfiguredConstraints)
    {
        // Vertically center both label and icon
        NSLayoutConstraint *labelCenterY = [NSLayoutConstraint constraintWithItem:[self label]
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self contentView]
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1 constant:0];
        
        NSLayoutConstraint *iconCenterY = [NSLayoutConstraint constraintWithItem:[self icon]
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self contentView]
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1 constant:0];
        
        // 16 pt leading space for label
        NSLayoutConstraint *labelLeading = [NSLayoutConstraint constraintWithItem:[self label]
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self contentView]
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1 constant:MARGIN_LEFTRIGHT];
        // 16pt trailing space for icon
        NSLayoutConstraint *iconTrailing = [NSLayoutConstraint constraintWithItem:[self contentView]
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:[self icon]
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1 constant:MARGIN_LEFTRIGHT];
        
        // Icon is 25pt by 25pt
        NSLayoutConstraint *iconWidth = [NSLayoutConstraint constraintWithItem:[self icon]
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1 constant:WIDTH_ICON];
        
        NSLayoutConstraint *iconHeight = [NSLayoutConstraint constraintWithItem:[self icon]
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1 constant:WIDTH_ICON];
        
        // Add all the constraints
        [[self contentView] addConstraint:labelCenterY];
        [[self contentView] addConstraint:iconCenterY];
        [[self contentView] addConstraint:labelLeading];
        [[self contentView] addConstraint:iconTrailing];
        [[self icon] addConstraint:iconWidth];
        [[self icon] addConstraint:iconHeight];
        
        // Set flag
        alreadyConfiguredConstraints = TRUE;
    }
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
