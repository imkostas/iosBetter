//
//  RankBarView.h
//  Better
//
//  Created by Peter on 6/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface RankBarView : UIView

// The color to fill the bars with, and the un-filled color
@property (strong, nonatomic) UIColor *unfilledColor;
@property (strong, nonatomic) UIColor *filledColor;

// Flags that specify which segments should be filled or not
@property (nonatomic) BOOL firstSegmentFilled;
@property (nonatomic) BOOL secondSegmentFilled;
@property (nonatomic) BOOL thirdSegmentFilled;
@property (nonatomic) BOOL fourthSegmentFilled;
@property (nonatomic) BOOL fifthSegmentFilled;

@end
