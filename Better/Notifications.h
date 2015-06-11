//
//  Notifications.h
//  Better
//
//  Created by Peter on 6/11/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface Notifications : UIViewController

// Called when the switches are toggled
- (IBAction)votesOnPostValueChanged:(id)sender;
- (IBAction)favoritesPostValueChanged:(id)sender;
- (IBAction)gainFollowerValueChanged:(id)sender;

// Outlets to the switches
@property (weak, nonatomic) IBOutlet UISwitch *votesOnPostSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *favoritesPostSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gainFollowerSwitch;

@end
