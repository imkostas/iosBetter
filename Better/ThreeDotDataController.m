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

/** AFNetworking manager used for all requests */
@property (strong, nonatomic) AFHTTPSessionManager *networkManager;

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
        _networkManager = [AFHTTPSessionManager manager];
        
        // Set up network manager
        [_networkManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_networkManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
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
    
    // Send the request
    NSString *requestString = [NSString stringWithFormat:@"%@post/detail/%i/%i", [[self user] uri], [post postID], [[self user] userID]];
    [[self networkManager] GET:requestString
                    parameters:nil
                       success:^(NSURLSessionDataTask *task, id responseObject) {
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
                           BOOL postHasVotes = ([post numberOfVotesTotal] > 0) ? TRUE : FALSE;
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
                               [favPostObject setObjectID:[post postID]];
                               
                               // <username>
                               ThreeDotObject *usernameObject = [[ThreeDotObject alloc] initWithType:ThreeDotObjectTypeUsername];
                               [usernameObject setTitle:[post username]];
                               [usernameObject setActive:followingUser];
                               [usernameObject setObjectID:[post userID]];
                               
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
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           
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
- (void)cancelDownloads
{
    [[[self networkManager] tasks] enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL *stop) {
        [task cancel];
    }];
}

#pragma mark - Favoriting, following
// Changing active state for a given ThreeDotObject
- (void)toggleActiveStateForThreeDotObject:(ThreeDotObject *)threeDotObject atIndexPath:(NSIndexPath *)indexPath
{
    // Do not continue if the ThreeDotObject is currently changing
    if([threeDotObject isChangingActiveState])
        return;
    else
        [threeDotObject setChangingActiveState:YES]; // Prevent repeated network requests
    
    // Otherwise, set up a request depending on its type and its current state
    BOOL newState = ([threeDotObject isActive]) ? FALSE : TRUE;
    
    // Create strings from the threeDotObject's object ID and the current user's user ID for use in the
    // parameters dictionary or URL string
    NSString *objectIDString = [NSString stringWithFormat:@"%i", [threeDotObject objectID]];
    NSString *currentUserIDString = [NSString stringWithFormat:@"%i", [[self user] userID]];
    
    // Going to active state (i.e. making a POST request)
    if(newState == TRUE)
    {
        // To give to the request
        NSString *requestString;
        NSDictionary *requestParameters;
        
        // These are cases only for favoriting/following, not unfavoriting/unfollowing
        switch([threeDotObject type])
        {
            case ThreeDotObjectTypeFavoritePost:
                requestString = [[[self user] uri] stringByAppendingString:@"favoritepost"];
                requestParameters = @{@"api_key":[[self user] apiKey],
                                      @"post_id":objectIDString,
                                      @"user_id":currentUserIDString};
                break;
                
            case ThreeDotObjectTypeUsername:
                requestString = [[[self user] uri] stringByAppendingString:@"follow"];
                requestParameters = @{@"api_key":[[self user] apiKey],
                                      @"user_id":objectIDString,
                                      @"follower_id":currentUserIDString};
                break;
                
            case ThreeDotObjectTypeHashtag:
                requestString = [[[self user] uri] stringByAppendingString:@"favoritehashtag"];
                requestParameters = @{@"api_key":[[self user] apiKey],
                                      @"hashtag_id":objectIDString,
                                      @"user_id":currentUserIDString};
                break;
                
            case ThreeDotObjectTypeReportMisuse:
                break;
                
            case ThreeDotObjectTypeVoters:
            default:
                break;
        }
        
        // Send a POST request
        [[self networkManager] POST:requestString
                         parameters:requestParameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                // Finally set the active state to the new state
                                [threeDotObject setActive:newState];
                                
                                // Reset the flag for changing the active state
                                [threeDotObject setChangingActiveState:NO];
                                
                                // Notify to reload the given index path
                                if([self delegate])
                                    [[self delegate] threeDotDataController:self didReloadItemsAtIndexPaths:@[indexPath]];
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                // Reset the flag for changing the active state
                                [threeDotObject setChangingActiveState:NO];
                                
                                NSLog(@"**!!** Network error: %@", [error localizedDescription]);
                            }];
    }
    else // New state is off/false
    {
        // To give to the request
        NSString *requestString;
        
        switch([threeDotObject type])
        {
            case ThreeDotObjectTypeFavoritePost:
            {
                NSString *suffix = [NSString stringWithFormat:@"favoritepost/%@/%@", objectIDString, currentUserIDString];
                requestString = [[[self user] uri] stringByAppendingString:suffix];
                break;
            }
                
            case ThreeDotObjectTypeUsername:
            {
                NSString *suffix = [NSString stringWithFormat:@"follow/%@/%@", objectIDString, currentUserIDString];
                requestString = [[[self user] uri] stringByAppendingString:suffix];
                break;
            }
                
            case ThreeDotObjectTypeHashtag:
            {
                NSString *suffix = [NSString stringWithFormat:@"favoritehashtag/%@/%@", objectIDString, currentUserIDString];
                requestString = [[[self user] uri] stringByAppendingString:suffix];
                break;
            }
                
            case ThreeDotObjectTypeReportMisuse:
            case ThreeDotObjectTypeVoters:
            default:
                break;
        }
        
        // Send a DELETE request
        [[self networkManager] DELETE:requestString
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  // Finally set the active state to the new state
                                  [threeDotObject setActive:newState];
                                  
                                  // Reset the flag for changing the active state
                                  [threeDotObject setChangingActiveState:NO];
                                  
                                  // Notify to reload the given index path
                                  if([self delegate])
                                      [[self delegate] threeDotDataController:self didReloadItemsAtIndexPaths:@[indexPath]];
                                  
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  
                                  // Reset the flag for changing the active state
                                  [threeDotObject setChangingActiveState:NO];
                                  
                                  NSLog(@"**!!** Network error: %@", [error localizedDescription]);
                                  
                              }];
    }
}

@end
