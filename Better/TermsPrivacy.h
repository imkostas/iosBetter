//
//  TermsPrivacy.h
//  Better
//
//  Created by Peter on 6/11/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface TermsPrivacy : UITabBarController <UITabBarControllerDelegate>

// Optionally set by another view controller to determine which tab the tab bar
// should display when it is first shown
@property (nonatomic) unsigned int openingTabIndex;

@end
