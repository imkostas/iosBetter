//
//  BELine.m
//  Better
//
//  Created by Peter on 5/28/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  Inspired by the one-pixel high code in Apple sample code "Customizing UINavigationBar"

#import "BELine.h"

@implementation BELine

// Called when view is going to be displayed
- (void)willMoveToWindow:(UIWindow *)newWindow
{
	// Make us one pixel in height
	CGRect newFrame = [self frame];
	newFrame.size.height = 1.0f / [[UIScreen mainScreen] scale];
	
	// Set the new size
	[self setFrame:newFrame];
	
	// Turn on clipping
	[self setClipsToBounds:YES];
}

@end
