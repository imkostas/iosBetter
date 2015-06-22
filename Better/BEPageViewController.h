//
//  BEPageViewController.h
//  Better
//
//  Created by Peter on 6/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BEPageViewController;
@protocol BEPageViewControllerDataSource <NSObject>

@required
// Ask the delegate for an array of viewcontrollers to show
- (NSArray *)viewControllersForPageViewController:(BEPageViewController *)pageViewController;

@end

@protocol BEPageViewControllerDelegate <NSObject>

@optional
// Tell the delegate that the page has changed
- (void)pageViewController:(BEPageViewController *)pageViewController switchedToPage:(NSInteger)page;

@end


@interface BEPageViewController : UIViewController <UIScrollViewDelegate>

// Datasource to get viewcontrollers from
@property (weak, nonatomic) id<BEPageViewControllerDataSource> dataSource;
// Delegate to notify when the page changes
@property (weak, nonatomic) id<BEPageViewControllerDelegate> delegate;

// ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
