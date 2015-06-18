//
//  RankBarView.m
//  Better
//
//  Created by Peter on 6/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "RankBarView.h"

@interface RankBarView ()
{
	// Values for drawing the segments
	CGFloat firstSegmentWidth;
	CGFloat segmentHeight;
	CGFloat segmentYPosition;
}

// Draw a segment, given its index (0 to 4)
- (void)drawSegmentAtIndex:(NSUInteger)index filled:(BOOL)shouldFill withCGContext:(CGContextRef)graphics;

@end

@implementation RankBarView

// Default initializations
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self defaultInit];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self defaultInit];
	}
	return self;
}

// Called by -initWithFrame: and -initWithCoder:
- (void)defaultInit
{
	// Initialize to defaults:
	
	_unfilledColor = [UIColor lightGrayColor];
	_filledColor = COLOR_BETTER_DARK;
	
	_firstSegmentFilled = FALSE;
	_secondSegmentFilled = FALSE;
	_thirdSegmentFilled = FALSE;
	_fourthSegmentFilled = FALSE;
	_fifthSegmentFilled = FALSE;
	
	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Calculate segment values:
	// Equation to find width of the first bar:
	// x = (z - 3y) / (1+2+4+8+16)
	// where:
	// x -> width of first segment
	// y -> width of space between segments (padding)
	// z -> width of the frame of this UIView
//	NSLog(@"frame size(%.1f,%.1f)", [self frame].size.width, [self frame].size.height);
	
	firstSegmentWidth = ([self frame].size.width - 4*PADDING_MYRANKING_BETWEEN_SEGMENTS) / (1+2+4+8+16);
	segmentHeight = [self frame].size.height * HEIGHT_MYRANKING_SEGMENT_PERCENT_OF_VIEW_HEIGHT;
	segmentYPosition = ([self frame].size.height - segmentHeight) / 2;
	
	// Drawing code
	// This is not really meant to be used for something that has a number of segments that is not 5,
	// though you can probably get it to work pretty easily by changing the equation for firstSegmentWidth
	// above (changing the divisor 1+2+4+... and changing the _*PADDING_MYRANKING_...)
	
	// Get contextRef
	CGContextRef graphics = UIGraphicsGetCurrentContext();
	
	// Draw
	[self drawSegmentAtIndex:0 filled:_firstSegmentFilled withCGContext:graphics];
	[self drawSegmentAtIndex:1 filled:_secondSegmentFilled withCGContext:graphics];
	[self drawSegmentAtIndex:2 filled:_thirdSegmentFilled withCGContext:graphics];
	[self drawSegmentAtIndex:3 filled:_fourthSegmentFilled withCGContext:graphics];
	[self drawSegmentAtIndex:4 filled:_fifthSegmentFilled withCGContext:graphics];
}

// More automated method of drawing a segment
- (void)drawSegmentAtIndex:(NSUInteger)index filled:(BOOL)shouldFill withCGContext:(CGContextRef)graphics
{
	// Set the color first
	if(shouldFill)
		CGContextSetFillColorWithColor(graphics, [_filledColor CGColor]);
	else
		CGContextSetFillColorWithColor(graphics, [_unfilledColor CGColor]);
	
	// Set up its drawing rectangle
	CGRect segmentRect;
	
		// Add in the padding first
	segmentRect.origin.x = (index * PADDING_MYRANKING_BETWEEN_SEGMENTS);
		// Add in the other segments
	for(int i = 0; i < index; i++)
		segmentRect.origin.x += firstSegmentWidth * pow(2, i);
		// Set y-value
	segmentRect.origin.y = segmentYPosition;
	
	segmentRect.size = CGSizeMake(firstSegmentWidth * pow(2, index), segmentHeight);
	
//	NSLog(@"drawing rect origin(%.1f,%.1f); size(%.1f,%.1f)", segmentRect.origin.x, segmentRect.origin.y, segmentRect.size.width, segmentRect.size.height);
	
	// Draw it
	CGContextFillRect(graphics, segmentRect);
}

@end
