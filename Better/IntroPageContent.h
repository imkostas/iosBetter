//
//  IntroPageContent.h
//  Better
//
//  Created by Peter on 5/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IntroPageContent : NSObject

// An image to show as the background of this page
@property (nonatomic, strong)	UIImage *image;

// Strings for each line of the page
@property (nonatomic, strong)	NSString *firstLine;
@property (nonatomic, strong)	NSString *secondLine;
@property (nonatomic, strong)	NSString *thirdLine;

// A boolean which indicates whether the first line should be styled as a title (TRUE)
// or not (FALSE)
@property (nonatomic)			BOOL firstLineIsTitle;

// Initialization method
- (instancetype)initWithFirstLine:(NSString *)first secondLine:(NSString *)second thirdLine:(NSString *)third firstLineIsTitle:(BOOL)isTitle image:(UIImage *)img;

@end
