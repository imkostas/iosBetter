//
//  Post.h
//  Better
//
//  Created by Peter on 7/27/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#ifndef Better_Post_h
#define Better_Post_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

#pragma mark -
/**
 A class to hold the properties of a vote by the current user,
 this doesn't represent the vote(s) of other users
 **/
@interface MyVote : NSObject

/** Uniquely identifies a vote */
@property (nonatomic)           int voteID;

/** The post that this vote applies to */
@property (nonatomic)           int postID;

/** The user who created this vote */
@property (nonatomic)           int userID;

/** When the vote was created */
@property (strong, nonatomic)   NSDate *creationDate;

@end

#pragma mark -
/** A class to hold all of the properties of a post
 **/
@interface PostObject : NSObject

/** Uniquely identifies a post */
@property (nonatomic)           int postID;

/** User's id */
@property (nonatomic)           int userID;

/** The layout type of this post. See enum LAYOUTSTATE in Definitions.h */
@property (nonatomic)           int layoutType;

/** The pixel coordinates of the center of hotspot A */
@property (nonatomic)           CGPoint hotspotALocation;

/** The pixel coordinates of the center of hotspot B */
@property (nonatomic)           CGPoint hotspotBLocation;

/** When the post was created */
@property (strong, nonatomic)   NSDate *creationDate;

/** Username of user who created this post */
@property (strong, nonatomic)   NSString *username;

/** Array of NSStrings, each representing a hashtag (without the hash symbol) */
@property (strong, nonatomic)   NSArray *tags; // Array of NSStrings

/** An NSAttributedString that is a concatenation of the hashtag strings stored in the array `tags`.
 The string is colored gray except for the text of the 1st and 2nd hashtag. */
@property (strong, nonatomic)   NSAttributedString *tagsAttributedString;

/** How many total votes on the post (both hotspots combined) */
@property (nonatomic)           int numberOfVotesTotal;

/** How many votes on hotspot A */
@property (nonatomic)           int numberOfVotesForA;

/** How many votes on hotspot B */
@property (nonatomic)           int numberOfVotesForB;

/** This user's vote for this specific post (nil if the user has not voted on this post) */
@property (strong, nonatomic)   MyVote *myVote;

@end

#endif
