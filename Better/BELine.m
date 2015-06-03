////
////  BELine.m
////  Better
////
////  Created by Peter on 5/28/15.
////  Copyright (c) 2015 Company. All rights reserved.
////
//
//#import "BELine.h"
//
//@implementation BELine
//
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//	// Color the view its own background color, but doing this in -drawRect lets us make sure it is
//	// exactly the height that it is supposed to be, and not antialiased/scaled, which is what normally
//	// happens
//	
//	// Draw into the same width and height as our frame (scaled), but not at an offset (x,y)
//	CGRect targetRect = [self frame];
//	targetRect.origin.x = 0;
//	targetRect.origin.y = 0;
//	targetRect.size.width /= [[UIScreen mainScreen] scale];
//	targetRect.size.height /= [[UIScreen mainScreen] scale];
//	
//	UIColor *fillColor = [self backgroundColor]; // get our background color
//	[self setBackgroundColor:[UIColor clearColor]]; // remove the background
//	CGContextRef graphics = UIGraphicsGetCurrentContext(); // get the graphics context to draw into
//	
//	CGContextSetFillColorWithColor(graphics, [fillColor CGColor]); // set the color
//	CGContextFillRect(graphics, targetRect); // draw the color
//}
//
//@end
