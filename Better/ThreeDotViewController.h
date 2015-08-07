//
//  ThreeDotViewController.h
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfo.h"
#import "ThreeDotDataController.h"
#import "ThreeDotTransitionAnimator.h"
#import "ThreeDotTableViewCell.h"
#import "PostObject.h"

@interface ThreeDotViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, ThreeDotDataControllerDelegate>

/** Custom initializer for passing a ThreeDotDataObject to this viewcontroller */
//- (instancetype)initWithThreeDotDataObject:(ThreeDotDataObject *)object;
/** Custom initializer for passing a PostObject to this viewcontroller */
- (instancetype)initWithPostObject:(PostObject *)post;

/** The data source for this object */
@property (strong, nonatomic) ThreeDotDataController *dataController;

@end
