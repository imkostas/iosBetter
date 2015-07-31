//
//  FeedTableViewCell.h
//  CustomTableViews
//
//  Created by Peter on 6/26/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "FeedCell.h"
#import "BEHotspotView.h"
#import "BEFadingImageView.h"

@interface FeedCellSingleImage : FeedCell

// The main image (one of them for this cell)
@property (weak, nonatomic) IBOutlet BEFadingImageView *mainImageView;

@end
