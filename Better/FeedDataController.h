//
//  FeedDataController.h
//  Better
//
//  Created by Peter on 7/27/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "Definitions.h"
#import "UserInfo.h"
#import "PostObject.h" // Where MyVote and PostObject are defined

@class FeedDataController;
@protocol FeedDataControllerDelegate <NSObject>

@required
/** Tells the delegate that the FeedDataController has finished reloading all post data */
- (void)feedDataControllerDidReloadAllPosts:(FeedDataController *)feedDataController;

/** Tells the delegate that the FeedDataController has finished loading a post at particular indexes/rows. The
 delegate should update the outwardly-visible UI corresponding to these posts in response to this method. i.e.
 using -insertRowAtIndexPath: ... */
- (void)feedDataController:(FeedDataController *)feedDataController didLoadPostsAtIndexPaths:(NSArray *)loadedPaths removePostsAtIndexPaths:(NSArray *)removedPaths;

/** Tells the delegate to scroll to the beginning of its content. This is usually called when changing the
 filter */
- (void)feedDataControllerDelegateShouldScrollToTopAnimated:(BOOL)animated;

/** Tells the delegate that the FeedDataController has deleted posts at particular index paths. The delegate should
 remove the UI elements corresponding to these posts. */
//- (void)feedDataController:(FeedDataController *)feedDataController didRemovePostsAtIndexPaths:(NSArray *)indexPaths;

@end

@interface FeedDataController : NSObject

/** The delegate to notify of events */
@property (weak, nonatomic) id<FeedDataControllerDelegate> delegate;

/** The current filter for loading posts (Everything / Following / etc.) */
@property (strong, nonatomic) NSString *filterString;

#pragma mark - Initialization
/** Returns a FeedDataController with a certain feed filter string */
- (instancetype)initWithFeedFilter:(NSString *)newFilterString;

#pragma mark - Instance methods
/** Returns the total number of post objects held by this FeedDataController */
- (NSUInteger)numberOfPosts;

/** Returns the PostObject corresponding to the given indexPath's row property */
- (PostObject *)postAtIndexPath:(NSIndexPath *)indexPath;

/** Load the next set of posts from the server with the specified filter */
- (void)loadPostsIncremental;

/** Discards all data and reloads from the beginning (most recent) */
- (void)reloadAllPosts;

/** Downloads the necessary images for a particular index path */
//- (void)downloadImagesForIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Class methods
/** Returns an NSAttributedString given an array of NSStrings (each represents a hashtag). This method
 assumes that the individual strings do not start with a '#'. It creates a string whose text color is gray
 except for the first two hashtags, which are colored black */
+ (NSAttributedString *)attributedStringForHashtagArray:(NSArray *)hashtags;

@end
