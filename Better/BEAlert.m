////
////  BEAlert.m
////  Better
////
////  Created by Peter on 7/8/15.
////  Copyright (c) 2015 Company. All rights reserved.
////
//
//#import "BEAlert.h"
//
//@interface BEAlert ()
//
//// Reference to a view controller to present the UIAlertController from (only applies to iOS 8)
//@property (weak, nonatomic) UIViewController *presentingViewController;
//
//// For iOS 8
//@property (strong, nonatomic) UIAlertController *alertController;
//// For iOS 7
//@property (strong, nonatomic) UIAlertView *alertView;
//
//@end
//
//@implementation BEAlert
//
//+ (BEAlert *)alertWithPresentingViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rightButtonTitle
//{
//    BEAlert *alert = [[BEAlert alloc] init];
//    
//    if([UIAlertController class]) // Detect iOS 8 or above
//    {
//        // Create a UIAlertController, add actions to it
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        
//    }
//    
//    return alert;
//}
//
//// Call -show on the UIAlertView, or call -presentViewController on `presentingViewController` with the
//// UIAlertController as a parameter
//- (void)show
//{
//    
//}
//
//@end
