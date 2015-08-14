//
//  VotersDataController.h
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "UserInfo.h"
#import "VoterObject.h"
#import "PostObject.h"

@class VotersDataController;
@protocol VotersDataControllerDelegate <NSObject>

@required
/** Notifies the delegate when this VotersDataController loads and/or removes voter objects at given index paths */
- (void)votersDataController:(VotersDataController *)votersDataController didLoadVotersAtIndexPaths:(NSArray *)loadedPaths removeVotersAtIndexPaths:(NSArray *)removedPaths;

/** Notifies the delegate that this VotersDataController has new data for the given index paths */
- (void)votersDataController:(VotersDataController *)votersDataController didReloadVotersAtIndexPaths:(NSArray *)reloadedPaths;

@end

@interface VotersDataController : NSObject

/** The delegate to notify of events */
@property (weak, nonatomic) id<VotersDataControllerDelegate> delegate;

/** Returns the number of voters */
- (NSInteger)numberOfVoterObjects;

/** Returns the voter object at this specific indexPath */
- (VoterObject *)voterObjectAtIndexPath:(NSIndexPath *)indexPath;

/** Loads a next set of voters with a certain limit */
- (void)loadVotersIncrementalWithLimit:(NSUInteger)limit;

/** Tells this VotersDataController to reload all the voters */
- (void)reloadAllVotersWithLimit:(NSUInteger)limit;

/** Toggles the active state of a VotersObject at a certain indexPath (in response to following or un-following a user) */
- (void)toggleActiveStateForIndexPath:(NSIndexPath *)indexPath;

/** Custom init */
- (instancetype)initWithPostObject:(PostObject *)postObject;

@end
