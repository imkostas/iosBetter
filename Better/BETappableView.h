//
//  BEGestureView.h
//  Better
//
//  Created by Peter on 6/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  The purpose of this class is to abstract away the use of a UIGestureRecognizer on a UIView. Instead of a
//  view controller, or other object, having to create and possibly store a UIGestureRecognizer for a certain
//  UIView, as well as organize a whole system of figuring out which recognizer belongs to which view,
//  they can instead implement a delegate method and respond to calls from this object.

//  It's intended for use with the tappable UIViews in the left and right drawers of the Feed

#import <UIKit/UIKit.h>

@class BETappableView;
@protocol BETappableViewDelegate <NSObject>

@required
// Notify the delegate when a gesture is 'activated' (gesture calls the action method specified with its
// -addTarget:action method)
- (void)gestureViewTapped:(BETappableView *)view withGesture:(UITapGestureRecognizer *)gesture;

@end


@interface BETappableView : UIView

@property (weak, nonatomic) id<BETappableViewDelegate> delegate; // The delegate to notify when a gesture is active
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture; // The tap gesture

@end
