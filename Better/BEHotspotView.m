//
//  BEHotspotView.m
//  CustomTableViews
//
//  Created by Peter on 7/2/15.
//  Copyright (c) 2015 BetterCompany. All rights reserved.
//

#import "BEHotspotView.h"

#define RATIO_CIRCULAR_STRIPE_THICKNESS_TO_HOTSPOT_DIAMETER 0.1 // This is 26/288 rounded (generously)

@interface BEHotspotView ()

// The background image for this view (the transparent, unfilled hotspot image)
@property (strong, nonatomic) UIImageView *backgroundImageView;

// UILabel for showing the percentage text
@property (strong, nonatomic) UILabel *percentageLabel;

/** A CAShapeLayer for the green-colored ring that visually represents the percentage value of the hotspot */
@property (strong, nonatomic) CAShapeLayer *ringLayer;

@end

@implementation BEHotspotView

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		/** Initialize colors, background image, UI **/
        _showsPercentageValue = FALSE;
        _highlighted = FALSE;
		
		// Initialize
		[self setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hotspot"]]];
		[self setPercentageLabel:[[UILabel alloc] init]];
        [self setRingLayer:[CAShapeLayer layer]];
		
		// Configure properties
//		[[self percentageLabel] setBackgroundColor:[UIColor blueColor]];
		[[self percentageLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self percentageLabel] setTextColor:COLOR_GRAY];
        [[self percentageLabel] setHidden:YES]; // Start off hidden
		
		[[[self backgroundImageView] layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
		[[[self backgroundImageView] layer] setShouldRasterize:YES];
        
        [[self ringLayer] setStrokeColor:[COLOR_GRAY CGColor]];
        [[self ringLayer] setFillColor:nil];
        [[self ringLayer] setActions:@{@"strokeEnd":[NSNull null]}]; // Disable implicit animations for strokeEnd
		
		// Add all subviews
		[self addSubview:[self backgroundImageView]];
		[self addSubview:[self percentageLabel]];
        [[self layer] addSublayer:[self ringLayer]];
	}
	
	return self;
}

#pragma mark - View's layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
	/** Set up the background image, etc. **/
	
	// Background image
	[[self backgroundImageView] setFrame:[self bounds]];
    
    /** Set up the ring layer **/
    
    // Create a circle that fits within the bounds of this view (if line thickness is larger than 1, the
    // system draws the line/stroke so that the center of the stroke is traced by the middle of the path i.e.
    // the stroke sticks out to the left and to the right of the path -- hence the "0.5" and "2" multipliers
    // below to get a correct rectangle that doesn't cause the stroke to go outside the hotspot
    CGFloat translateXandY = 0.5 * CGRectGetWidth([self bounds]) * RATIO_CIRCULAR_STRIPE_THICKNESS_TO_HOTSPOT_DIAMETER;
    CGFloat sizeXandY = CGRectGetWidth([self bounds]) - 2 * translateXandY;
    CGRect ringRect = {};
    ringRect.origin = CGPointMake(translateXandY, translateXandY);
    ringRect.size = CGSizeMake(sizeXandY, sizeXandY);
    
    // Path -> circle that fits inside the above rectangle
    CGMutablePathRef ringLayerPathMutable = CGPathCreateMutable();
    CGPoint centerPoint = {};
    centerPoint.x = CGRectGetWidth(ringRect) / 2 + ringRect.origin.x;
    centerPoint.y = CGRectGetHeight(ringRect) / 2 + ringRect.origin.y;
    CGPathAddArc(ringLayerPathMutable, NULL, centerPoint.x, centerPoint.y, CGRectGetWidth(ringRect) / 2, -M_PI_2, 3*M_PI_2, FALSE);
    
    [[self ringLayer] setFrame:[self bounds]];
    [[self ringLayer] setPath:ringLayerPathMutable];
    [[self ringLayer] setLineWidth:CGRectGetWidth([self bounds]) * RATIO_CIRCULAR_STRIPE_THICKNESS_TO_HOTSPOT_DIAMETER];
	
	// Percentage label
	CGRect labelFrame;
	labelFrame.size.width = CGRectGetWidth([self bounds]);
	labelFrame.size.height = CGRectGetHeight([self bounds]) / 3;
	labelFrame.origin.x = 0;
	labelFrame.origin.y = (CGRectGetHeight([self bounds]) / 2) - (labelFrame.size.height / 2);
	[[self percentageLabel] setFrame:labelFrame];
}

#pragma mark - Setting properties
- (void)setPercentageValue:(float)percentageValue
{
	// Keep within zero and one
	if(percentageValue < 0) percentageValue = 0;
	if(percentageValue > 1) percentageValue = 1;
	
	/** Update the UILabel **/
	
	// Convert the value to a string with a number between 0 and 100
	NSString *percent = [NSString stringWithFormat:@"%i", (int)roundf(percentageValue * 100)];
	
	// The number should have large text while the "%" should have smaller text, so create an attributed
	// string with the correct ranges
	
	// For the number
	NSRange firstRange;
	firstRange.location = 0;
	firstRange.length = [percent length];
	
	// For the "%"
	NSRange secondRange;
	secondRange.location = [percent length];
	secondRange.length = 1;
	
	// Create the attributed string
	NSMutableAttributedString *percentageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%", percent]];
    [percentageString beginEditing];
	[percentageString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26] range:firstRange];
	[percentageString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:secondRange];
    [percentageString endEditing];
	
	// Apply it to the label
	[[self percentageLabel] setAttributedText:percentageString];
    
    // Update ring layer's percentage-filled with the system's default function for animating ui elements
    CAKeyframeAnimation *ringAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    CAMediaTimingFunction *ringAnimationFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    // Start at zero and end at the percentage value
    [ringAnimation setValues:@[[NSNumber numberWithInt:0], [NSNumber numberWithFloat:percentageValue]]];
    [ringAnimation setTimingFunction:ringAnimationFunction];
    [ringAnimation setDuration:(1.75 * sqrt(percentageValue))];
    
    // Run the animation and actually apply the end value (without implicit animation)
    [[self ringLayer] addAnimation:ringAnimation forKey:@"strokeEnd"];
    [[self ringLayer] setStrokeEnd:percentageValue]; // If not present, the ring flashes back to nothing

	// Finally record the new value
	_percentageValue = percentageValue;
}

- (void)setShowsPercentageValue:(BOOL)showsPercentageValue
{
    [[self percentageLabel] setHidden:(!showsPercentageValue)];
    [[self ringLayer] setHidden:(!showsPercentageValue)];
    
    // Store the new value
    _showsPercentageValue = showsPercentageValue;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if(highlighted)
    {
        // Make colors bright
        [[self ringLayer] setStrokeColor:[COLOR_BETTER CGColor]];
        [[self percentageLabel] setTextColor:COLOR_BETTER];
    }
    else
    {
        // Make colors dark
        [[self ringLayer] setStrokeColor:[COLOR_GRAY CGColor]];
        [[self percentageLabel] setTextColor:COLOR_GRAY];
    }
    
    // Store new value
    _highlighted = highlighted;
}

#pragma mark - Custom drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    /** Drawing code **/
//	
//	// Get reference to the graphics context
//	CGContextRef graphics = UIGraphicsGetCurrentContext();
//	
//	// Draw a circle
//	CGContextSetFillColorWithColor(graphics, [[UIColor colorWithRed:170/255. green:0 blue:0 alpha:1] CGColor]);
//	CGContextFillEllipseInRect(graphics, [self bounds]);
//}

@end
