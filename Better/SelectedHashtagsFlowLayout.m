//
//  SelectedHashtagsFlowLayout.m
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "SelectedHashtagsFlowLayout.h"

@implementation SelectedHashtagsFlowLayout

// Override super's implementation
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // Retrieve the values that the superclass would calculate
    NSArray *existingAttrs = [super layoutAttributesForElementsInRect:rect];
    
    return existingAttrs;
}

@end
