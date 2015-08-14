//
//  VotersDataController.m
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "VotersDataController.h"

@interface VotersDataController ()

/** Network manager */
@property (strong, nonatomic) AFHTTPSessionManager *networkManager;

/** Reference to UserInfo shared object */
@property (weak, nonatomic) UserInfo *user;

/** The array which holds the list of voters */
@property (strong, nonatomic) NSMutableArray *votersArray;

/** Flag that is set when we reach the end of the voters list */
@property (nonatomic) BOOL reachedEndOfVoters;

/** The vote ID of the least-recent voter object to be retrieved (used in the `last` parameter for the API) */
@property (nonatomic) int voteIDLeastRecent;

/** The post object to retrieve voter information for */
@property (strong, nonatomic) PostObject *postObject;

/** Holds the index paths that will be removed when we are in the process of reloading all the voters */
@property (strong, nonatomic) NSArray *indexPathsToRemove;

/** Flag that is set when we are in the process of reloading everything */
@property (nonatomic) BOOL inProcessOfDeletingAllVoters;

/** Loads some voters */
- (void)loadVotersIncrementalWithLimit:(NSUInteger)limit;

/** Internal method to process the completion of the network request, which in turn decides what to tell the
 delegate */
- (void)didLoadVotersAtIndexPaths:(NSArray *)indexPaths;

@end

@implementation VotersDataController

- (instancetype)initWithPostObject:(PostObject *)postObject
{
    self = [super init];
    if(self)
    {
        // Initialize data structures
        _votersArray = [[NSMutableArray alloc] init];
        _user = [UserInfo user];
        _postObject = postObject;
        _voteIDLeastRecent = 0;
        _inProcessOfDeletingAllVoters = FALSE;
        
        // Initialize networking
        _networkManager = [AFHTTPSessionManager manager];
        [_networkManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [_networkManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    
    return self;
}

#pragma mark - Instance methods
// loading voters
- (void)loadVotersIncrementalWithLimit:(NSUInteger)limit
{
    // url: 1.2.3.4/v1/post/voters/<post ID>/<my user ID>/<least-recent>/<limit>
    
    // Create the URL
    NSString *url = [NSString stringWithFormat:@"%@post/voters/%i/%i/%i/%i", [[self user] uri], [[self postObject] postID], [[self user] userID], _voteIDLeastRecent, limit];
    
    // Send the request
    [[self networkManager] GET:url
                    parameters:nil
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           
                           // Retrieve the `voters` array from within the `response` dictionary
                           NSDictionary *responseDict = [responseObject objectForKey:@"response"];
                           NSArray *voters = [responseDict objectForKey:@"voters"];
                           
                           // Stop if there are no more votes to show
                           if(voters == nil || [voters count] == 0)
                           {
                               // Tell the delegate there was nothing loaded
                               [self didLoadVotersAtIndexPaths:nil];
                               
                               // Don't send more network requests
                               _reachedEndOfVoters = TRUE;
                               return; // Stops this success block
                           }
                           
                           // Otherwise, parse through the info
                           NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] init];
                           for(NSDictionary *voter in voters)
                           {
                               SEL intValueSelector = @selector(intValue);
                               VoterObject *thisVote = [[VoterObject alloc] init];
                               
                               // Voter ID (comes as string)
                               id voterID = [voter objectForKey:@"id"];
                               if([voterID respondsToSelector:intValueSelector])
                                   [thisVote setVoteID:[voterID intValue]];
                               
                               // User ID (comes as string)
                               id userID = [voter objectForKey:@"user_id"];
                               if([userID respondsToSelector:intValueSelector])
                                   [thisVote setUserID:[userID intValue]];
                               
                               // Username
                               [thisVote setUsername:[voter objectForKey:@"username"]];
                               
                               // Active state (comes as an NSNumber)
                               id following = [voter objectForKey:@"following"];
                               if([following respondsToSelector:intValueSelector])
                                   [thisVote setActive:[following intValue]];
                               
                               // Add an index path for this vote
                               [updatedIndexPaths addObject:[NSIndexPath indexPathForRow:[[self votersArray] count] inSection:0]];
                               
                               // Add this new vote to the voters array
                               [[self votersArray] addObject:thisVote];
                               
                               // Keep track of least-recent voter
                               _voteIDLeastRecent = [thisVote voteID];
                           }
                           
                           // Notify ourselves
                           [self didLoadVotersAtIndexPaths:updatedIndexPaths];
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           
                           // Notify ourselves
                           [self didLoadVotersAtIndexPaths:nil];
                           
                           NSLog(@"**!!** Error loading voter data: %@", [error localizedDescription]);
                       }];
}

// Returns the VoterObject at the given indexPath
- (VoterObject *)voterObjectAtIndexPath:(NSIndexPath *)indexPath
{
    // Check the bounds of the indexPath's row
    if([indexPath row] < 0 || [indexPath row] >= [[self votersArray] count])
        return nil; // Out of bounds
    else
        return (VoterObject *)[[self votersArray] objectAtIndex:[indexPath row]];
}

// Returns the number of voters in the votersArray
- (NSInteger)numberOfVoterObjects
{
    return [[self votersArray] count];
}

// Reload everything
- (void)reloadAllVotersWithLimit:(NSUInteger)limit
{
    // Stop any connections in progress (loading voters, etc.)
    [[[self networkManager] tasks] enumerateObjectsUsingBlock:^(NSURLSessionDataTask *task, NSUInteger idx, BOOL *stop) {
        [task cancel];
    }];
    
    // Create an array of indexpaths that encompasses all of the current posts, in order to rememeber
    // which indexPaths to delete later
    NSMutableArray *removedPaths = [[NSMutableArray alloc] initWithCapacity:[[self votersArray] count]];
    for(int i = 0; i < [[self votersArray] count]; i++)
        [removedPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    // Save the array
    [self setIndexPathsToRemove:removedPaths];
    
    // Empty votersArray
    [[self votersArray] removeAllObjects];
    
    // Set/reset some flags and values
    _reachedEndOfVoters = FALSE;
    _inProcessOfDeletingAllVoters = TRUE;
    _voteIDLeastRecent = 0;
    
    // Start the load process
    [self loadVotersIncrementalWithLimit:limit];
}

// Toggle active or not
- (void)toggleActiveStateForIndexPath:(NSIndexPath *)indexPath
{
    // Get the VoterObject for this indexPath
    VoterObject *thisVoter = [self voterObjectAtIndexPath:indexPath];
    
    // Do not continue if this voter object is alraedy in the process of changing its active state
    if([thisVoter isChangingActiveState])
        return;
    else
        [thisVoter setChangingActiveState:YES];
    
    // Set new state
    BOOL newState = ([thisVoter isActive]) ? FALSE : TRUE;
    
    if(newState == TRUE) // Make a POST request
    {
        // Send request
        [[self networkManager] POST:[[[self user] uri] stringByAppendingString:@"follow"]
                         parameters:@{@"api_key":[[self user] apiKey],
                                      @"user_id":[NSString stringWithFormat:@"%i", [thisVoter userID]],
                                      @"follower_id":[NSString stringWithFormat:@"%i", [[self user] userID]]}
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                
                                // Set active state to new state
                                [thisVoter setActive:newState];
                                
                                // Reset flag for changing the active state
                                [thisVoter setChangingActiveState:NO];
                                
                                // Notify to reload this index path
                                if([self delegate])
                                    [[self delegate] votersDataController:self didReloadVotersAtIndexPaths:@[indexPath]];
                            }
                            failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                                // Reset the flag for changing the active state
                                [thisVoter setChangingActiveState:NO];
                                
                                NSLog(@"**!!** Network error: %@", [error localizedDescription]);
                            }];
    }
    else // Make a DELETE request
    {
        // Send request
        NSString *urlString = [NSString stringWithFormat:@"%@follow/%i/%i", [[self user] uri], [thisVoter userID], [[self user] userID]];
        [[self networkManager] DELETE:urlString
                           parameters:nil
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  // Set active state to new state
                                  [thisVoter setActive:newState];
                                  
                                  // Reset flag for changing the active state
                                  [thisVoter setChangingActiveState:NO];
                                  
                                  // Notify to reload this index path
                                  if([self delegate])
                                      [[self delegate] votersDataController:self didReloadVotersAtIndexPaths:@[indexPath]];
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  
                                  // Reset the flag for changing the active state
                                  [thisVoter setChangingActiveState:NO];
                                  
                                  NSLog(@"**!!** Network error: %@", [error localizedDescription]);
                              }];
    }
}

#pragma mark - Private instance methods
// Called in response to loading or not loading some voter data
- (void)didLoadVotersAtIndexPaths:(NSArray *)indexPaths
{
    // Notify the delegate
    if([self delegate])
    {
        // Are we reloading all the voters?
        if(_inProcessOfDeletingAllVoters)
        {
            // Reset the flag
            _inProcessOfDeletingAllVoters = FALSE;
            
            // Tell the delegate to update
            if([[self indexPathsToRemove] count] == 0)
            {
                // Prevents a crash when you tell the UITableView to remove index paths and give it an empty
                // array (we want to give it nil)
                [[self delegate] votersDataController:self
                            didLoadVotersAtIndexPaths:indexPaths
                             removeVotersAtIndexPaths:nil];
            }
            else
            {
                [[self delegate] votersDataController:self
                            didLoadVotersAtIndexPaths:indexPaths
                             removeVotersAtIndexPaths:[self indexPathsToRemove]];
            }
        }
        else // Add objects as normal
        {
            [[self delegate] votersDataController:self
                        didLoadVotersAtIndexPaths:indexPaths
                         removeVotersAtIndexPaths:nil];
        }
    }
}

@end
