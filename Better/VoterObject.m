//
//  VoterObject.m
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "VoterObject.h"

@implementation VoterObject

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _voteID = -1;
        _userID = -1;
        _username = nil;
        _active = FALSE;
        _changingActiveState = FALSE;
    }
    
    return self;
}

@end
