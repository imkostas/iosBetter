//
//  Settings.h
//  Better
//
//  Created by Peter on 6/9/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "BETappableView.h"
#import "CustomAlert.h"
#import "AppDelegate.h"

@interface Settings : UIViewController <BETappableViewDelegate>//, CustomAlertDelegate>

// Outlets to each of the tappable areas inside the Settings menu
@property (weak, nonatomic) IBOutlet BETappableView *myAccountView;
@property (weak, nonatomic) IBOutlet BETappableView *notificationsView;
@property (weak, nonatomic) IBOutlet BETappableView *supportView;
@property (weak, nonatomic) IBOutlet BETappableView *logoutView;

// A CustomAlert for logging out
@property (strong, nonatomic) CustomAlert *logoutAlert;

// Called when the back arrow in the navigation bar is pressed
- (IBAction)backArrowPressed:(id)sender;

@end
