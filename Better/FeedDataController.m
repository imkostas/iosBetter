//
//  FeedDataController.m
//  Better
//
//  Created by Peter on 7/27/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "FeedDataController.h"

#define POSTS_PER_DOWNLOAD 5

@interface FeedDataController ()
{
    // Set to TRUE when the API returns an empty posts array, signaling that there are no more posts to show
    
}

/** Reference to UserInfo shared object */
@property (weak, nonatomic) UserInfo *user;

/** The array of PostObjects*/
@property (strong, nonatomic) NSMutableArray *postsArray;

/** The post ID of the least-recent (farthest back in time) post loaded so far */
@property int postIDLeastRecent;

/** Set to TRUE when the API returns an empty posts array, signaling that there are no more posts to show */
@property BOOL reachedEndOfPostsIncremental;

/** Set to TRUE when the user has just changed the filter for the feed and we are deleting all previous posts */
@property BOOL inProcessOfChangingFilter;
/** Set to an array of NSIndexPaths to delete upon completing the change of filter (within -didLoadPostsAtIndexPaths:) */
@property (strong, nonatomic) NSArray *indexPathsToRemove;

/** Private instance method for parsing through a JSON dictionary representation of a post. It returns a
 PostObject populated with the values of the NSDictionary it is given */
- (PostObject *)parseJSONPostObject:(NSDictionary *)postDictionary;

/** Private instance method to respond to the loading of post data, which in turn notifies the delegate of
 inserted and deleted rows */
- (void)didLoadPostsAtIndexPaths:(NSArray *)loadedPaths;

@end

@implementation FeedDataController

#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        // Get a reference to the UserInfo object
        _user = [UserInfo user];
        
        // Initialize state variables
        _postsArray = [[NSMutableArray alloc] initWithCapacity:POSTS_PER_DOWNLOAD];
        _postIDLeastRecent = 0; // Initialize postIDLeastRecent to zero (loads the most recent post first)
        _reachedEndOfPostsIncremental = FALSE;
        _inProcessOfChangingFilter = FALSE;
        _filterString = @"";
    }
    
    return self;
}

- (instancetype)initWithFeedFilter:(NSString *)filterString
{
    self = [super init];
    if(self)
    {
        // Get a reference to the UserInfo object
        _user = [UserInfo user];
        
        // Initialize state variables
        _postsArray = [[NSMutableArray alloc] initWithCapacity:POSTS_PER_DOWNLOAD];
        _postIDLeastRecent = 0; // Initialize postIDLeastRecent to zero (loads the most recent post first)
        _reachedEndOfPostsIncremental = FALSE;
        _inProcessOfChangingFilter = FALSE;
        _filterString = filterString;
    }
    
    return self;
}

#pragma mark - Instance methods
// Downloads `POSTS_PER_DOWNLOAD` number of posts and adds them as PostObjects to the end of `postsArray`
- (void)loadPostsIncremental
{
    // url is like this: 10.20.30.40/v1/post/<CurrentUserID>/<StartFromThisPostIDGoingBackwards>/<MaxNumberToDownload>
    
    // Stop if there are no more posts to show
    if(_reachedEndOfPostsIncremental)
        return;
    
    // Set up AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Turn on the network indicator
    [[self user] setNetworkActivityIndicatorVisible:YES];
    
    // Send the GET request
    [manager GET:[NSString stringWithFormat:@"%@post/%@%i/%i/%i", [[self user] uri], _filterString, [[self user] userID], [self postIDLeastRecent], POSTS_PER_DOWNLOAD]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // Turn off the network indicator
             [[self user] setNetworkActivityIndicatorVisible:NO];
             
             // Get the `response` dictionary. Within it is an array named `feed`.
             NSArray *feedArray = [[responseObject objectForKey:@"response"] objectForKey:@"feed"];
             
             // Stop if there are no more posts to show
             if(feedArray == nil || [feedArray count] == 0)
             {
                 // Don't send more network requests
                 _reachedEndOfPostsIncremental = TRUE;
                 return; // Stops this success block
             }
             
             // Loop through each post dictionary returned and create a PostObject from it
             NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] init];
             for(NSDictionary *postDictionary in feedArray)
             {
                 // Generate a PostObject from this NSDictionary
                 PostObject *thisPost = [self parseJSONPostObject:postDictionary];
                 
                 // Save an indexPath corresponding to this post object
                 [updatedIndexPaths addObject:[NSIndexPath indexPathForRow:[[self postsArray] count] inSection:0]];
                 
                 // Save this post in the postsArray
                 [[self postsArray] addObject:thisPost];
                 
                 // Keep track of the least-recent post that's been loaded
                 _postIDLeastRecent = [thisPost postID];
             }
             
             // Updating tableviews and things like that need to happen on the main thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 // Notify ourselves first to process what to tell the delegate
                 [self didLoadPostsAtIndexPaths:updatedIndexPaths];
                 
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // Turn off the network indicator
             [[self user] setNetworkActivityIndicatorVisible:NO];
             
             // Updating tableviews and things like that need to happen on the main thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 // Even though there was a network error, it's still important to update the delegate
                 // on what happened because, for example, a UITableView will throw an
                 // NSInternalInconsistencyException if the data behind it becomes undefined in the event
                 // of a network error or failure to download something
                 [self didLoadPostsAtIndexPaths:nil];
                 
             });
             
             NSLog(@"**!!** Error while loading post data: %@, %@", [error localizedDescription], [error localizedFailureReason]);
         }];
}

// Returns the PostObject at this indexPath's -row in the `postsArray` mutable array
- (PostObject *)postAtIndexPath:(NSIndexPath *)indexPath
{
    // Check the bounds of the indexPath's row
    if([indexPath row] < 0 || [indexPath row] >= [[self postsArray] count])
        return nil; // Out of bounds
    else
        return (PostObject *)[[self postsArray] objectAtIndex:[indexPath row]];
}

// Returns the number of objects in `postsArray`
- (NSUInteger)numberOfPosts
{
    return [[self postsArray] count];
}

// Deletes all objects in `postsArray`
//- (void)removeAllPosts
//{
//    // Create an array of indexpaths that encompasses all of the posts
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:[[self postsArray] count]];
//    for(int i = 0; i < [[self postsArray] count]; i++)
//        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    
//    // Tell the delegate that these posts have been deleted
////    if([self delegate])
////        [[self delegate] feedDataController:self didRemovePostsAtIndexPaths:indexPaths];
//    
//    // Get rid of the elements
//    [[self postsArray] removeAllObjects];
//    
//    // Reset the "end of feed" flag
//    reachedEndOfPostsIncremental = FALSE;
//}

// Custom setter for filterString
- (void)setFilterString:(NSString *)newFilterString
{
    // Store the old filter string for comparison
    NSString *previousFilterString = [[self filterString] copy];
    
    // Record the change
    _filterString = newFilterString;
    
    // Only reload everything if the filter has changed
    if(![previousFilterString isEqualToString:newFilterString])
    {
        // Create an array of indexpaths that encompasses all of the current posts, in order to rememeber
        // which indexPaths to delete later
        NSMutableArray *removedPaths = [[NSMutableArray alloc] initWithCapacity:[[self postsArray] count]];
        for(int i = 0; i < [[self postsArray] count]; i++)
            [removedPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        // Save the array
        [self setIndexPathsToRemove:removedPaths];
        
        // Empty `postsArray`
        [[self postsArray] removeAllObjects];
        
        // Reset the "end of feed" flag
        _reachedEndOfPostsIncremental = FALSE;
        
        // Reset the least recent post ID
        _postIDLeastRecent = 0;
        
        // Perform actions that only happen when changing the filter string
        _inProcessOfChangingFilter = TRUE;
        
        // Start the post loading process
        [self loadPostsIncremental];
    }
}

#pragma mark - Private instance methods
// Turns an NSDictionary into a PostObject
- (PostObject *)parseJSONPostObject:(NSDictionary *)postDictionary
{
    PostObject *post = [[PostObject alloc] init];
    
    // Date formatter for converting strings to NSDates
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Make sure these are strings before converting them to integers
    SEL intValueSelector = @selector(intValue);
    
    // Post ID
    id postID = [postDictionary objectForKey:@"id"];
    if([postID respondsToSelector:intValueSelector])
        [post setPostID:[postID intValue]];
    
    // User ID
    id userID = [postDictionary objectForKey:@"user_id"];
    if([userID respondsToSelector:intValueSelector])
        [post setUserID:[userID intValue]];
    
    // Username string
    id username = [postDictionary objectForKey:@"username"];
    [post setUsername:username];
    
    // Layout type
    id layoutType = [postDictionary objectForKey:@"layout"];
    if([layoutType respondsToSelector:intValueSelector])
        [post setLayoutType:[layoutType intValue]];
    
    // Hotspot A's location
    id hotspotOneX = [postDictionary objectForKey:@"hotspot_one_x"];
    id hotspotOneY = [postDictionary objectForKey:@"hotspot_one_y"];
    if([hotspotOneX respondsToSelector:intValueSelector] && [hotspotOneY respondsToSelector:intValueSelector])
        [post setHotspotALocation:CGPointMake([hotspotOneX intValue], [hotspotOneY intValue])];
    
    // Hotspot B's location
    id hotspotTwoX = [postDictionary objectForKey:@"hotspot_two_x"];
    id hotspotTwoY = [postDictionary objectForKey:@"hotspot_two_y"];
    if([hotspotTwoX respondsToSelector:intValueSelector] && [hotspotTwoY respondsToSelector:intValueSelector])
        [post setHotspotBLocation:CGPointMake([hotspotTwoX intValue], [hotspotTwoY intValue])];
    
    // Creation date
    id creationDate = [postDictionary objectForKey:@"created_at"];
    if([creationDate isKindOfClass:[NSString class]])
    {
        // Set up the date formatter (string is like this: "2015-07-21 19:30:01")
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [post setCreationDate:[dateFormatter dateFromString:creationDate]];
    }
    
    // Number of votes (comes as an int, but gets converted to an NSNumber)
    id numberOfVotes = [postDictionary objectForKey:@"votes"];
    if([numberOfVotes respondsToSelector:intValueSelector])
        [post setNumberOfVotes:[numberOfVotes intValue]];
    
    // Hashtags
    id hashtags = [postDictionary objectForKey:@"hashtags"];
    if([hashtags respondsToSelector:@selector(componentsSeparatedByString:)])
        [post setTags:[hashtags componentsSeparatedByString:@" "]]; // Each separated by a space
    
    // Also make an NSAttributedString out of this array of hashtags (for displaying at the top
    // of a FeedCell
    [post setTagsAttributedString:[FeedDataController attributedStringForHashtagArray:[post tags]]];
    
    // Vote (could be FALSE or an NSDictionary)
    id vote = [postDictionary objectForKey:@"vote"];
    if([vote respondsToSelector:@selector(objectForKey:)]) // Is it a dictionary
    {
        // Create a MyVote object for this vote
        MyVote *thisVote = [[MyVote alloc] init];
        
        // Populate it with info:
        
        // Vote ID
        id voteID = [vote objectForKey:@"id"];
        if([voteID respondsToSelector:intValueSelector])
            [thisVote setVoteID:[voteID intValue]];
        
        // Post ID
        id postID = [vote objectForKey:@"post_id"];
        if([postID respondsToSelector:intValueSelector])
            [thisVote setPostID:[postID intValue]];
        
        // User ID
        id userID = [vote objectForKey:@"user_id"];
        if([userID respondsToSelector:intValueSelector])
            [thisVote setUserID:[userID intValue]];
        
        // Creation date
        id voteCreationDate = [vote objectForKey:@"created_at"];
        if([voteCreationDate isKindOfClass:[NSString class]])
            [thisVote setCreationDate:[dateFormatter dateFromString:voteCreationDate]];
        
        // Finally save the vote
        [post setMyVote:thisVote];
    }
    else if(vote == FALSE) // The current user has not voted on this post
        [post setMyVote:nil];
    
    // Return this new PostObject
    return post;
}

// Handles the completion of downloading data and removing posts and tells the delegate what to do
- (void)didLoadPostsAtIndexPaths:(NSArray *)loadedPaths
{
    // Notify the delegate that some cells have changed
    if([self delegate])
    {
        // Are we changing the filter string right now?
        if(_inProcessOfChangingFilter)
        {
            // Reset the flag
            _inProcessOfChangingFilter = FALSE;
            
            // Tell the delegate to update
            if([[self indexPathsToRemove] count] == 0)
            {
                [[self delegate] feedDataController:self
                           didLoadPostsAtIndexPaths:loadedPaths
                            removePostsAtIndexPaths:nil];
            }
            else
            {
                [[self delegate] feedDataController:self
                           didLoadPostsAtIndexPaths:loadedPaths
                            removePostsAtIndexPaths:[self indexPathsToRemove]];
            }
        }
        else
        {
            // Add objects as normal
            // Tell the delegate to update
            [[self delegate] feedDataController:self
                       didLoadPostsAtIndexPaths:loadedPaths
                        removePostsAtIndexPaths:nil];
        }
    }
}

#pragma mark - Class methods
// Creates an attributed string ("#hashtag #hello #blah") from an array of tags {"hashtag","hello","blah"}
+ (NSAttributedString *)attributedStringForHashtagArray:(NSArray *)hashtags
{
    // Place hashtag symbol (#) in front of each hashtag and place in a new string to give to the
    // NSMutableAttributedString
    NSMutableString *hashtagStringWithHashes = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < [hashtags count]; i++)
    {
        // Get the hashtag string at this index and append it to the mutable string
        NSString *thisHashtag = [hashtags objectAtIndex:i];
        [hashtagStringWithHashes appendString:[@"#" stringByAppendingString:thisHashtag]];
        
        // Add a space if we are not at the last index
        if(i < [hashtags count] - 1)
            [hashtagStringWithHashes appendString:@" "];
    }
    
    // Create NSRanges which correspond to the text of the first two hashtags
    // "#hashtag_#hello_#restofstring_#morehashtag"
    
    NSRange firstCharRange = { .location = 0, .length = 1 }; // "#"
    NSRange firstHashtagRange = { // "hashtag"
        .location = 1,
        .length = [[hashtags firstObject] length]
    };
    NSRange betweenFirstSecondRange = { // "_#"
        .location = firstHashtagRange.location + firstHashtagRange.length,
        .length = 2
    };
    NSRange secondHashtagRange = { // "hello"
        .location = betweenFirstSecondRange.location + betweenFirstSecondRange.length,
        .length = [[hashtags objectAtIndex:1] length]
    };
    NSRange restOfStringRange = { // "_#restofstring_#morehashtag....."
        .location = secondHashtagRange.location + secondHashtagRange.length,
        .length = [hashtagStringWithHashes length] - secondHashtagRange.length - betweenFirstSecondRange.length - firstHashtagRange.length - firstCharRange.length
    };
    
    // The whole string
    NSRange wholeRange = { .location = 0, .length = [hashtagStringWithHashes length] };
    
    // Get the font to be applied to this attributed string
    UIFont *hashtagsFont = [UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_FEEDCELL_HASHTAG_LABEL];
    
    // Now create the attributed string
    NSMutableAttributedString *hashtagStringAttr = [[NSMutableAttributedString alloc] initWithString:hashtagStringWithHashes];
    [hashtagStringAttr beginEditing];
    [hashtagStringAttr addAttribute:NSFontAttributeName value:hashtagsFont range:wholeRange];
    [hashtagStringAttr addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_STOCK range:firstCharRange];
    [hashtagStringAttr addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_CUSTOM range:firstHashtagRange];
    [hashtagStringAttr addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_STOCK range:betweenFirstSecondRange];
    [hashtagStringAttr addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_CUSTOM range:secondHashtagRange];
    [hashtagStringAttr addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_STOCK range:restOfStringRange];
    [hashtagStringAttr endEditing];
    
    // Return it
    return [hashtagStringAttr copy];
}

@end
