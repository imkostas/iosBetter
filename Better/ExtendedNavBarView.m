//
//  ExtendedNavBarView.m
//  Better
//
//  Created by Peter on 6/18/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  This is from the Apple sample code, "Customizing UINavigationBar"
//  https://developer.apple.com/library/ios/samplecode/NavBar/Introduction/Intro.html
//
//  This class draws a shadow under a UIView that mimics the one used under UINavigationBar

#import "ExtendedNavBarView.h"

@implementation ExtendedNavBarView

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	// Use the layer shadow to draw a one pixel hairline under this view.
	[self.layer setShadowOffset:CGSizeMake(0, 1.0f/UIScreen.mainScreen.scale)];
	[self.layer setShadowRadius:0];
	
	// UINavigationBar's hairline is adaptive, its properties change with
	// the contents it overlies.  You may need to experiment with these
	// values to best match your content.
	[self.layer setShadowColor:[UIColor blackColor].CGColor];
	[self.layer setShadowOpacity:0.25f];	
}

@end
