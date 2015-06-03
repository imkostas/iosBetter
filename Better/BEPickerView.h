//
//  BEDatePicker.h
//
//  Created by Peter on 6/2/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@class BEPickerView;

// Delegate protocol
@protocol BEPickerViewDelegate <NSObject>

@required
// Notify the delegate when the view is going to be dismissed
- (void)pickerViewWillDismiss:(BEPickerView *)pickerView;

@end

@interface BEPickerView : UIView

@property (weak, nonatomic) id <BEPickerViewDelegate> delegate; // The delegate
													// Used for the method(s) above in BEPickerViewDelegate

// Make the picker public so that other classes can be its datasource and delegate, but keep it from being
// written over
@property (strong, nonatomic, readonly) UIPickerView *picker;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSLayoutConstraint *pickerShowHideConstraint; // Constraint for showing/
																			// hiding the picker elements

// Showing and hiding
- (void)show;
- (void)dismiss; // This calls -removeFromSuperview

@end
