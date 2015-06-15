//
//  MyInformation.h
//  Better
//
//  Created by Peter on 6/15/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "UserInfo.h"

@interface MyInformation : UIViewController

// Profile image and panel
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *profilePanel;

// Rank and user information
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

// Pressing on bar button items
- (IBAction)backArrowPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

@end
