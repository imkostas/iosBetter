//
//  ThreeDotViewController.h
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThreeDotTransitionAnimator.h"
#import "ThreeDotTableViewCell.h"
#import "ThreeDotDataObject.h"

@interface ThreeDotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

/** Custom initializer for passing a ThreeDotDataObject to this viewcontroller */
- (instancetype)initWithThreeDotDataObject:(ThreeDotDataObject *)object;

@end
