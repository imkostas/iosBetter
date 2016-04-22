//
//  BEImageResponseSerializer.h
//  Better
//
//  Created by Peter on 8/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <AFNetworking/AFURLResponseSerialization.h>

@interface BEImageResponseSerializer : AFImageResponseSerializer

/** Holds the size of the rectangle that the image will be drawn into, which downscales the image if this size
 is smaller than the image's size. */
//@property (nonatomic, assign) CGSize destinationSize;

/** Reference to a UIImageView whose dimensions will be retrieved directly before the image is returned and
 set as the `image` property of the given UIImageView */
@property (weak, nonatomic) UIImageView *imageView;

/** If you'd like to have this serializer scale down the image to the size of the UIImageView it will be placed
 inside, pass a reference to said UIImageView here */
- (instancetype)initWithImageView:(UIImageView *)imageView;

@end
