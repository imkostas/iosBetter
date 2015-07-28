//
//  FeedTopBottomCell.h
//  CustomTableViews
//
//  Created by Peter on 6/29/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "FeedCell.h"

@interface FeedCellTopBottom : FeedCell

// Top and bottom images of the post
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@end
