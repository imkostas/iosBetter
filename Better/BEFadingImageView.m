//
//  BEFadingImageView.m
//  Better
//
//  Created by Peter on 7/31/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEFadingImageView.h"

@interface BEFadingImageView ()

@property (strong, nonatomic) BEImageResponseSerializer *scalingImageResponseSerializer;

@end

@implementation BEFadingImageView

- (void)commonInit
{
    _scalingImageResponseSerializer = [[BEImageResponseSerializer alloc] initWithImageView:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self commonInit];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self commonInit];
    }
    
    return self;
}

// Override the normal -setImage: method
//- (void)setImage:(UIImage *)image
//{
//    // Prevent flashing
//    [self setAlpha:0];
//    
//    // Get this object's CALayer
//    CALayer *layer = [self layer];
//    
//    // Draw the image
//    [super setImage:image];
//    
//    // Make the layer hidden first
//    [layer setOpacity:0];
//    
//    // Re-show ourselves
//    [self setAlpha:1];
//
//    // Create an animation to fade in the image
//    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    [fadeAnimation setFromValue:[NSNumber numberWithInt:0]];
//    [fadeAnimation setToValue:[NSNumber numberWithInt:1]];
//    [fadeAnimation setDuration:ANIM_DURATION_POST_FADE_IMAGE]; // 200ms
//    [layer addAnimation:fadeAnimation forKey:@"opacity"];
//    
//    // Apply the final value (prevents flashing back to hidden)
//    [layer setOpacity:1.0];
//}

// Gives our custom image serializer to AFNetworking (comment out this method to cancel out all of the custom
// code, if it's causing problems)
- (id<AFURLResponseSerialization>)imageResponseSerializer
{
//    [[self scalingImageResponseSerializer] setDestinationSize:[self bounds].size];
//    NSLog(@"image scale size: %.1f,%.1f", self.bounds.size.width, self.bounds.size.height);    
    return _scalingImageResponseSerializer;
}

@end
