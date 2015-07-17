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

@class BEPostingHotspotView;
@protocol BEPostingHotspotViewDelegate <NSObject>

@required
/**
 Tells the delegate that the user wants to apply this hashtag (typed in)
 **/
- (void)postingHotspotView:(BEPostingHotspotView *)hotspotView didEndEditingHashtag:(NSString *)hashtag;

@end

@interface BEPostingHotspotView : UIImageView <UITextFieldDelegate>

// A delegate for this object (should be PostLayoutViewController)
@property (weak, nonatomic) id<BEPostingHotspotViewDelegate> delegate;

// The "applied"/current hashtag string
@property (strong, nonatomic) NSString *hashtagString;

@end
