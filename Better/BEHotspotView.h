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

// Holds the percentage value of this hotspot (this is a number between 0 and 1, and is also used to update
// the UILabel when its value is set)
@property (nonatomic) float percentageValue;

// BOOL for selected or not selected (green color or gray color theme)
@property (nonatomic) BOOL selected;

@end
