//
//  ThreeDotObject.m
//  Better
//
//  Created by Peter on 8/7/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotObject.h"

@implementation ThreeDotObject

// Custom initalizer
- (instancetype)initWithType:(ThreeDotObjectType)type
{
    self = [super init];
    if(self)
    {
        // Set up instance variables
        _type = type;
        _objectID = -1;
        _title = nil;
        _attributedTitle = nil;
        _active = FALSE;
    }
    
    return self;
}

@end
