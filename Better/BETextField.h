//
//  BetterTextField.h
//  Better
//
//  Created by Peter on 5/20/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface BETextField : UITextField

// References to the UIImageViews in the leftView and rightView properties of this UITextField.
// These will be non-nil if we have set the images with -setLeftViewToImageNamed: or -setRightViewToImageNamed:,
// and nil otherwise. They are declared as 'weak' because if the text field's leftView and/or rightView are set
// to something else (without using the below methods), we don't want them anymore (can release their memory).
@property (weak, nonatomic) UIImageView *leftImageView;
@property (weak, nonatomic) UIImageView *rightImageView;

// Given a filename, these methods will create a UIImageView from an image with the given filename and
// set it up as either a left or right view of this BETextField
- (void)setLeftViewToImageNamed:(NSString *)leftImageName;
- (void)setRightViewToImageNamed:(NSString *)rightImageName;

// Given a filename, these methods will change the image of the leftView and rightView properties without
// getting rid of the UIImageView itself... the purpose of this is to be able to update the picture
// without having to re-generate a whole UIImageView and set its properties each time (gestures,
// userInteractionEnabled, etc.....
- (void)updateLeftViewImageToImageNamed:(NSString *)leftImageName;
- (void)updateRightViewImageToImageNamed:(NSString *)rightImageName;

@end
