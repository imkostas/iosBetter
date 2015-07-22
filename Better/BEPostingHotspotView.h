//
//  BEPostingHotspotView.h
//  Better
//
//  Created by Peter on 7/17/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "BETextField.h"

@interface BEPostingHotspotView : UIImageView <UITextFieldDelegate>

// The "applied"/current hashtag string
@property (strong, nonatomic) NSString *hashtagString;

@end
