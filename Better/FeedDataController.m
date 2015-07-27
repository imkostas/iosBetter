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

/** Reference to UserInfo shared object */
@property (weak, nonatomic) UserInfo *user;

/** The array of PostObjects*/
@property (strong, nonatomic) NSMutableArray *postsArray;

/** The post ID of the least-recent (farthest back in time) post loaded so far */
@property (nonatomic) int postIDLeastRecent;

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
        
        // Initialize the postsArray
        _postsArray = [[NSMutableArray alloc] initWithCapacity:POSTS_PER_DOWNLOAD];
        
        // Initialize postIDLeastRecent to zero (loads the most recent post first)
        _postIDLeastRecent = 0;
    }
    
    return self;
}

#pragma mark - Networking
// Downloads `POSTS_PER_DOWNLOAD` number of posts and adds them as PostObjects to the end of `postsArray`
- (void)loadPostsIncremental
{
    // url is like this: 10.20.30.40/v1/post/<CurrentUserID>/<StartFromThisPostIDGoingBackwards>/<MaxNumberToDownload>
    
    // Set up AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Turn on the network indicator
    [[self user] setNetworkActivityIndicatorVisible:YES];
    
    // Send the GET request
    [manager GET:[NSString stringWithFormat:@"%@post/%i/%i/%i", [[self user] uri], [[self user] userID], [self postIDLeastRecent], POSTS_PER_DOWNLOAD]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // Turn off the network indicator
             [[self user] setNetworkActivityIndicatorVisible:NO];
             
             // Get the `response` dictionary. Within it is an array named `feed`.
             NSArray *feedArray = [[responseObject objectForKey:@"response"] objectForKey:@"feed"];
             
             // Date formatter for converting strings to NSDates
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             
             // Loop through each post dictionary returned and create a PostObject from it
             NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] init];
             for(NSDictionary *postDictionary in feedArray)
             {
                 PostObject *post = [[PostObject alloc] init];
                 
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
                     [post setCreationDate:[dateFormatter dateFromString:creationDate]];
                 
                 // Number of votes (comes as an int, but gets converted to an NSNumber)
                 id numberOfVotes = [postDictionary objectForKey:@"votes"];
                 if([numberOfVotes respondsToSelector:intValueSelector])
                     [post setNumberOfVotes:[numberOfVotes intValue]];
                 
                 // Hashtags
                 id hashtags = [postDictionary objectForKey:@"hashtags"];
                 if([hashtags respondsToSelector:@selector(componentsSeparatedByString:)])
                     [post setTags:[hashtags componentsSeparatedByString:@" "]]; // Each separated by a space
                 
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
                 
                 // Save an indexPath corresponding to this post object
                 [updatedIndexPaths addObject:[NSIndexPath indexPathForRow:[[self postsArray] count] inSection:0]];
                 
                 // Save this post in the postsArray
                 [[self postsArray] addObject:post];
                 
                 // Keep track of the least-recent post that's been loaded
                 _postIDLeastRecent = [post postID];
             }
             
             // Notify the delegate that some cells have changed
             if([self delegate])
                 [[self delegate] feedDataController:self didReloadPostsAtIndexPaths:[updatedIndexPaths copy]];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"**!!** Error while loading post data");
         }];
}

#pragma mark - Instance methods
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

@end
