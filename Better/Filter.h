//
//  FilterViewController.h
//  Better
//
//  Created by Peter on 6/4/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETappableView.h"

@protocol FilterDelegate <NSObject>

@required
// Notify the delegate when the filter changes
- (void)filterChanged:(NSString *)filterString;
- (void)filterSearchDidBegin:(UISearchBar *)searchBar;
- (void)filterSearchDidEnd:(UISearchBar *)searchBar;

@end

@interface FilterViewController : UIViewController <BETappableViewDelegate, UISearchBarDelegate>

// The search bar
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

// Outlets for each of the filtering options; each are a UIView
@property (weak, nonatomic) IBOutlet BETappableView *everythingView;
@property (weak, nonatomic) IBOutlet BETappableView *favoriteTagsView;
@property (weak, nonatomic) IBOutlet BETappableView *followingView;
@property (weak, nonatomic) IBOutlet BETappableView *trendingView;

// Delegate of this class--used for notifying when the filter has changed
@property (weak, nonatomic) id<FilterDelegate> delegate;

@end
