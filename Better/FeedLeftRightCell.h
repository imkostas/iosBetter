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

@interface FeedLeftRightCell : FeedCell

// Left and right images
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
