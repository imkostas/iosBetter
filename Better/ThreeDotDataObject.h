//
//  ThreeDotDataObject.h
//  Better
//
//  Created by Peter on 8/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeDotDataObject : NSObject

/** Set to TRUE when the post being represented by this ThreeDotDataObject is one of the user's own posts,
 and FALSE otherwise */
@property (nonatomic, getter=isOwnPost) BOOL ownPost;

/** Set to TRUE when there are more than zero votes on the post represented by this ThreeDotDataObject, and
 FALSE otherwise */
@property (nonatomic) BOOL hasVotes;

/** Username of the person who posted this post */
@property (strong, nonatomic) NSString *username;

/** An array of NSStrings representing the hashtags of this post */
@property (strong, nonatomic) NSArray *tags;

@end
