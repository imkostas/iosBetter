//
//  BEDatePicker.h
//  PickerTest
//
//  Created by Peter on 6/1/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@class BEDatePickerView;

// Delegate protocol
@protocol BEDatePickerViewDelegate <NSObject>

@required
// Notify the delegate when the view is going to be dismissed
- (void)datePickerWillDismiss:(BEDatePickerView *)datePickerView;

// Notify delegate when the date changes
- (void)datePickerValueChanged:(BEDatePickerView *)datePickerView;

@end


@interface BEDatePickerView : UIView

@property (weak, nonatomic) id <BEDatePickerViewDelegate> delegate; // The delegate

// This mirrors the same property in the implementation file but makes the datePicker readonly so it
// can't be modified by other objects
@property (strong, nonatomic, readonly) UIDatePicker *picker;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSLayoutConstraint *pickerShowHideConstraint; // Constraint for showing/
																			// hiding the picker elements

//- (void)setDate:(NSDate *)date; // Sets the date property of the UIDatePicker
//- (NSDate *)date; // Returns the date property of the UIDatePicker

// Showing and hiding
- (void)show;
- (void)dismiss; // This calls -removeFromSuperview

@end
