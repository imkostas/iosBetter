//
//  BELabel.h
//  Better
//
//  Created by Peter on 6/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface BELabel : UILabel

// Method to revert this label's font back to the default font
- (void)revertToDefaultFont;

// Method/property to bold/unbold the font
@property (nonatomic, getter=isEmphasized) BOOL emphasized;

@end
