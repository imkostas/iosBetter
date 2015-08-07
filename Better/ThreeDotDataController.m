//
//  ThreeDotDataController.m
//  Better
//
//  Created by Peter on 8/7/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "ThreeDotDataController.h"

@interface ThreeDotDataController ()

/** Reference to UserInfo object */
@property (weak, nonatomic) UserInfo *user;

/** The array of ThreeDotObjects */
@property (strong, nonatomic) NSArray *threeDotArray;

/** Reference to the GET request started by AFNetworking, so we can cancel it if necessary */
@property (weak, nonatomic) AFHTTPRequestOperation *networkRequest;

@end

@implementation ThreeDotDataController

#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        // Initialize variables
        _user = [UserInfo user];
    }
    
    return self;
}

#pragma mark - Instance methods
// Downloads all post detail data and discards previous data
- (void)reloadDataWithPostObject:(PostObject *)post
{
    // url like this: 1.2.3.4/v1/post/detail/<PostID>/<MyUserID>
    
    // Don't do anything if postObject is not set
    if(!post)
        return;
    
    // Set up AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Turn on the network indicator
    [[self user] setNetworkActivityIndicatorVisible:YES];
    
    // send the request
    NSString *requestString = [NSString stringWithFormat:@"%@post/detail/%i/%i", [[self user] uri], [post postID], [[self user] userID]];
    _networkRequest = [manager GET:requestString
                        parameters:nil
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               // Turn off the network indicator
                               [[self user] setNetworkActivityIndicatorVisible:NO];
                               
                               // Get the response dictionary and list of hashtags
                               NSDictionary *response = [responseObject objectForKey:@"response"];
                               NSArray *hashtagInfoArray = [response objectForKey:@"favorite_hashtags"];
                               
                               // Make sure we can proceed
                               if([[post tags] count] != [hashtagInfoArray count])
                               {
                                   // aw shit
                                   // call delegate reloaditems with nil parameter
                                   return;
                               }
                               
                               // Determine whether to add Voters, Favorite Post, username, Report Misuse objects
                               BOOL postHasVotes = ([post numberOfVotes] > 0) ? TRUE : FALSE;
                               BOOL isOwnPost = ([post userID] == [[self user] userID]) ? TRUE : FALSE;
                               
                               BOOL favoritedPost = FALSE;
                               if([response objectForKey:@"favorited_post"] == [NSNumber numberWithInt:1])
                                   favoritedPost = TRUE;
                               
                               BOOL followingUser = FALSE;
                               if([response objectForKey:@"following"] == [NSNumber numberWithInt:1])
                                   followingUser = TRUE;
                               
                               // Begin adding ThreeDotObjects
                               NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
                               
                               // Add the "Votes" if applicable
                               if(postHasVotes)
                               {
                                   ThreeDotObject *votesObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeVoters];
                                   [votesObject setTitle:STRING_VOTERS];
                                   
                                   [objectsArray addObject:votesObject];
                               }
                               
                               // Add "Favorite Post" and the username rows if applicable
                               if(!isOwnPost)
                               {
                                   // Fav Post
                                   ThreeDotObject *favPostObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeFavoritePost];
                                   [favPostObject setTitle:STRING_FAVORITE_POST];
                                   [favPostObject setActive:favoritedPost];
                                   
                                   // <username>
                                   ThreeDotObject *usernameObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeUsername];
                                   [usernameObject setTitle:[post username]];
                                   [usernameObject setActive:followingUser];
                                   
                                   [objectsArray addObject:favPostObject];
                                   [objectsArray addObject:usernameObject];
                               }
                               
                               // Now add the hashtags (we checked earlier if the two arrays have the same
                               // number of items
                               for(NSUInteger i = 0; i < [[post tags] count]; i++)
                               {
                                   // Get the hashtag string
                                   NSString *tag = [[post tags] objectAtIndex:i];
                                   // Retrieve the corresponding NSDictionary inside the favorite_hashtags array-
                                   // each dictionary has two keys: 'hashtag_id' and 'favorited'
                                   NSDictionary *tagDict = [hashtagInfoArray objectAtIndex:i];
                                   
                                   // Construct a ThreeDotObject
                                   ThreeDotObject *tagObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeHashtag];
                                   
                                       // hashtag ID
                                   id hashtagIDObject = [tagDict objectForKey:@"hashtag_id"];
                                   if([hashtagIDObject respondsToSelector:@selector(intValue)])
                                       [tagObject setObjectID:[hashtagIDObject intValue]]; // Store it
                                   
                                       // Favorited or not
                                   if([tagDict objectForKey:@"favorited"] == [NSNumber numberWithInt:1])
                                       [tagObject setActive:YES]; // Store it
                                   
                                       // Create the NSAttributedString
                                   NSString *tagWithHash = [@"#" stringByAppendingString:tag];
                                   NSRange firstCharRange = { .location = 0, .length = 1 };
                                   NSMutableAttributedString *hashtagString = [[NSMutableAttributedString alloc] initWithString:tagWithHash];
                                   [hashtagString beginEditing];
                                   [hashtagString addAttribute:NSForegroundColorAttributeName value:COLOR_FEED_HASHTAGS_STOCK range:firstCharRange];
                                   [hashtagString endEditing];
                                   [tagObject setAttributedTitle:[hashtagString copy]]; // Store it
                                   
                                   // Add to objects array
                                   [objectsArray addObject:tagObject];
                               }
                               
                               // Finally...  Report Misuse
                               if(!isOwnPost)
                               {
                                   ThreeDotObject *reportMisuseObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeReportMisuse];
                                   [reportMisuseObject setTitle:STRING_REPORT_MISUSE];
                                   
                                   // Add to objects array
                                   [objectsArray addObject:reportMisuseObject];
                               }
                               
                               // Save the data
                               [self setThreeDotArray:objectsArray];
                               
                               // Now notify the delegate which index paths to reload
                               NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] initWithCapacity:[[self threeDotArray] count]];
                               for(NSUInteger i = 0; i < [[self threeDotArray] count]; i++)
                                   [indexPathsToReload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                               
                               // Run on main thread
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   // Notify delegate
                                   if([self delegate])
                                       [[self delegate] threeDotDataController:self didLoadItemsAtIndexPaths:indexPathsToReload];
                               });
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               // Turn off network indicator
                               [[self user] setNetworkActivityIndicatorVisible:NO];
                               
                               // Run on main thread
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   // Notify delegate
                                   if([self delegate])
                                       [[self delegate] threeDotDataController:self didLoadItemsAtIndexPaths:nil];
                               });
                           }];
}

// Number of items in threeDotArray
- (NSInteger)numberOfItems
{
    return [[self threeDotArray] count];
}

// Return threeDotObject at certain index path
- (ThreeDotObject *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    // Check the bounds of the indexPath's row
    if([indexPath row] < 0 || [indexPath row] >= [[self threeDotArray] count])
        return nil; // Out of bounds
    else
        return (ThreeDotObject *)[[self threeDotArray] objectAtIndex:[indexPath row]];
}

// Cancels the download, if there is one
- (void)cancelDownload
{
    if([self networkRequest])
        [[self networkRequest] cancel];
}

@end
