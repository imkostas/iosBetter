//
//  ThreeDotTransitionAnimator.m
//  Better
//
//  Created by Peter on 8/3/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotTransitionAnimator.h"

#define ANIM_DURATION 0.5f

@implementation ThreeDotTransitionAnimator

// Duration of the animation in seconds
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return ANIM_DURATION;
}

// Perform the animation itself
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Get the presenting (from) and presented (to) view controllers from `transitionContext`
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Disable user interaction for now
    [[toVC view] setUserInteractionEnabled:NO];
    [[fromVC view] setUserInteractionEnabled:NO];
    
    // Perform different animation if we are presenting vs. dismissing
    if([self presenting])
    {
        // Add the destination VC's view as a subview of the transition's containerView
        [[transitionContext containerView] addSubview:[toVC view]];
        
        // Start off with zero alpha
        [[toVC view] setAlpha:0.0f];
    }
    else // Dismissing
    {
        // Nothing necessary here
    }
    
    // Animate (iOS style spring damping)
    [UIView animateWithDuration:ANIM_DURATION
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if([self presenting])
                             [[toVC view] setAlpha:1];
                         else
                             [[fromVC view] setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         // Reenable user interaction
                         [[toVC view] setUserInteractionEnabled:YES];
                         [[fromVC view] setUserInteractionEnabled:YES];
                         
                         // Complete the transition
                         [transitionContext completeTransition:finished];
                     }];
}

@end
