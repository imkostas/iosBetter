//
//  BEImageResponseSerializer.h
//  Better
//
//  Created by Peter on 8/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIImage.h>
#import <AFNetworking/AFURLResponseSerialization.h>

@interface BEImageResponseSerializer : AFImageResponseSerializer

/** Holds the size of the rectangle that the image will be drawn into, which downscales the image if this size
 is smaller than the image's size. */
@property (nonatomic, assign) CGSize destinationSize;

@end
