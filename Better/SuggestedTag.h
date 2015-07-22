//
//  SuggestedTag.h
//  Better
//
//  Created by Peter on 7/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestedTag : NSObject

// The suggested tag
@property (strong, nonatomic) NSString *hashtag;

// Whether this tag has been selected by the user or not
@property (nonatomic, getter=isSelected) BOOL selected;

// Custom init
- (instancetype)initWithHashtag:(NSString *)hashtagString selected:(BOOL)selectedValue;

@end
