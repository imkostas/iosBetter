//
//  FeedLeftRightCell.h
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "FeedCell.h"
#import "BEFadingImageView.h"

@interface FeedCellLeftRight : FeedCell

// Left and right images
@property (weak, nonatomic) IBOutlet BEFadingImageView *leftImageView;
@property (weak, nonatomic) IBOutlet BEFadingImageView *rightImageView;

@end
