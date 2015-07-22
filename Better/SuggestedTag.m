//
//  SuggestedTag.m
//  Better
//
//  Created by Peter on 7/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "SuggestedTag.h"

@implementation SuggestedTag

// Custom init
- (instancetype)initWithHashtag:(NSString *)hashtagString selected:(BOOL)selectedValue
{
    self = [super init];
    if(self)
    {
        _hashtag = hashtagString;
        _selected = selectedValue;
    }
    
    return self;
}

@end
