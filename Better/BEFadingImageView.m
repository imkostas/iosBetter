//
//  BEFadingImageView.m
//  Better
//
//  Created by Peter on 7/31/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEFadingImageView.h"

@implementation BEFadingImageView

// Override the normal -setImage: method
- (void)setImage:(UIImage *)image
{
    // Get this object's CALayer
    CALayer *layer = [self layer];
    
    // Make the layer hidden first
    [layer setOpacity:0];
    
    // Apply the image
    [super setImage:image];
    
    // Create an animation to fade in the image
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeAnimation setFromValue:[NSNumber numberWithInt:0]];
    [fadeAnimation setToValue:[NSNumber numberWithInt:1]];
    [fadeAnimation setDuration:ANIM_DURATION_POST_FADE_IMAGE]; // 200ms
    [layer addAnimation:fadeAnimation forKey:@"opacity"];
    
    // Apply the final value (prevents flashing back to hidden)
    [layer setOpacity:1.0];
}

@end
