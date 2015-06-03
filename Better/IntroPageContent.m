//
//  IntroPageContent.m
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "IntroPageContent.h"

@implementation IntroPageContent

- (instancetype)initWithFirstLine:(NSString *)first secondLine:(NSString *)second thirdLine:(NSString *)third firstLineIsTitle:(BOOL)isTitle image:(UIImage *)img;
{
	self = [super init];
	if (self)
	{
		_firstLine = first;
		_secondLine = second;
		_thirdLine = third;
		_firstLineIsTitle = isTitle;
		_image = img;
	}
	return self;
}

@end
