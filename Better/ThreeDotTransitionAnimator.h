//
//  ThreeDotTransitionAnimator.h
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  http://www.teehanlax.com/blog/custom-uiviewcontroller-transitions/

#import <UIKit/UIViewControllerTransitioning.h>
#import "Definitions.h"

@interface ThreeDotTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/** Set to TRUE if this animator is being used to present a view controller, and FALSE when it is being
 used to dismiss a view controller */
@property (nonatomic) BOOL presenting;

@end
