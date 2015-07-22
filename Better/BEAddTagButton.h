//
//  BEAddTagButton.h
//  Better
//
//  Created by Peter on 7/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  ** Most (if not all) of this code is copied from BEPostingHotspotView.
//  I tried to make an object that would encapsulate all of the becomeFirstResponder, resignFirstResponder, etc.
//  stuff seen here and have the hotspots and this button class inherit from that one class, but it got really
//  messy... If I were to do that, the new object would inherit from UIView. That means that BEPostingHotspotView
//  wouldn't be able to be a UIImageView subclass anymore, since it's impossible to have it inherit from both the
//  new object and UIImageView at the same time. I'd prefer the ..HotspotView to be a UIImageView and not a
//  plain UIView.
//  I don't think a category would work either because this way of putting a textfield above the keyboard
//  involves storing a UITextField object and a string, and categories aren't designed to hold new properties
//  (is that true?)
//  So, the code is duplicated across two classes, this one and BEPostingHotspotView. Not ideal.. but I'm not
//  sure how to generalize the code without making other things messy.

#import "BEButton.h"
#import "BETextField.h"

@class BEAddTagButton;
@protocol BEAddTagButtonDelegate <NSObject>

@required
/**
 Tells the delegate that the user is done adding their custom hashtag
 */
- (void)addTagButton:(BEAddTagButton *)button finishedNewHashtag:(NSString *)hashtagString;

@end

@interface BEAddTagButton : BEButton <UITextFieldDelegate>

// The delegate for this object
@property (weak, nonatomic) id<BEAddTagButtonDelegate> delegate;

// The "applied"/current hashtag string
@property (strong, nonatomic) NSString *hashtagString;

@end
