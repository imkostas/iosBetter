//
//  BEHotspotView.h
//  CustomTableViews
//
//  Created by Peter on 7/2/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Definitions.h"

@interface BEHotspotView : UIView

/** Holds the percentage value of this hotspot (this is a number between 0 and 1, and is also used to update
 the UILabel when its value is set) */
@property (nonatomic) float percentageValue;

/** BOOL for whether the hotspot should show its percentage value and ring (user has voted), or hide them
 (user has not voted) */
@property (nonatomic) BOOL showsPercentageValue;

/** BOOL for whether the hotspot should be highlighted (i.e. it holds the greater percentage, and its ring
 and text should have a bright color), or unhighlighted (grayish color */
@property (nonatomic) BOOL highlighted;

@end
