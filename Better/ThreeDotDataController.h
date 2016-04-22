//
//  ThreeDotDataController.h
//  Better
//
//  Created by Peter on 8/7/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "UserInfo.h"
#import "ThreeDotObject.h"
#import "PostObject.h"

@class ThreeDotDataController;
@protocol ThreeDotDataControllerDelegate <NSObject>

@required
/** Tells the delegate that the ThreeDotDataController has finished loading particular rows and can insert these rows. */
- (void)threeDotDataController:(ThreeDotDataController *)threeDotDataController didLoadItemsAtIndexPaths:(NSArray *)indexPaths;

/** Tells the delegate that the ThreeDotDataController has new data for existing rows */
- (void)threeDotDataController:(ThreeDotDataController *)threeDotDataController didReloadItemsAtIndexPaths:(NSArray *)indexPaths;

@end

@interface ThreeDotDataController : NSObject

/** The delegate to notify of events */
@property (weak, nonatomic) id<ThreeDotDataControllerDelegate> delegate;

/** Returns the number of items within this ThreeDotDataController (corresponds to the number of rows) */
- (NSInteger)numberOfItems;

/** Returns the ThreeDotObject corresponding to the given indexPath */
- (ThreeDotObject *)itemAtIndexPath:(NSIndexPath *)indexPath;

/** Instructs this ThreeDotDataController to download the post detail data from the API. It discards the
 previous data. */
- (void)reloadDataWithPostObject:(PostObject *)post;

/** Instructs this ThreeDotDataController to cancel the current network request(s) if one is in progress. */
- (void)cancelDownloads;

/** Toggles the active state of the given ThreeDotObject if it is not already in the process of toggling,
 and notifies the delegate when the process has completed. */
- (void)toggleActiveStateForThreeDotObject:(ThreeDotObject *)threeDotObject atIndexPath:(NSIndexPath *)indexPath;

@end
