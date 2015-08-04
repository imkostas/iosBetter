//
//  ThreeDotTransitionAnimator.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotTransitionAnimator.h"

@implementation ThreeDotTransitionAnimator

// Duration of the animation in seconds
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
//    return ANIM_DURATION_SHOW_3DOT_MENU;
    return 0;
}

// Perform the animation itself
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the presenting (from) and presented (to) view controllers from `transitionContext`
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Perform different animation if we are presenting vs. dismissing
    if([self presenting])
    {
        // Disable user interaction on the fromVC when we are presenting
        [[fromVC view] setUserInteractionEnabled:NO];
        
        // Add the destination VC's view as a subview of the transition's containerView
        [[transitionContext containerView] addSubview:[toVC view]];
        
        // Start off with zero alpha
        [[toVC view] setAlpha:0.0f];
    }
    else // Dismissing
    {
        // Nothing
    }
    
    // Animate (iOS style spring damping)
    [UIView animateWithDuration:ANIM_DURATION_SHOW_3DOT_MENU
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if([self presenting])
                             [[toVC view] setAlpha:1.0f];
                         else
                             [[fromVC view] setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         // Reenable user interaction on the toVC when dismissing
                         if(![self presenting])
                             [[toVC view] setUserInteractionEnabled:YES];
                         
                         // Complete the transition
                         [transitionContext completeTransition:YES];
                     }];
}

@end
