//
//  BEImageResponseSerializer.m
//  Better
//
//  Created by Peter on 8/12/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "BEImageResponseSerializer.h"

/** Static methods copied from AFURLResponseSerialization.m **/
/*************************************************************/

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }
    
    return NO;
}
static UIImage * AFImageWithDataAtScale(NSData *data, CGFloat scale) {
    UIImage *image = [[UIImage alloc] initWithData:data];
    if (image.images) {
        return image;
    }
    
    return [[UIImage alloc] initWithCGImage:[image CGImage] scale:scale orientation:image.imageOrientation];
}
static UIImage * BEInflatedImageFromResponseWithDataAtScale(NSHTTPURLResponse *response, NSData *data, CGFloat scale, CGSize destinationSize)
{
    if (!data || [data length] == 0) {
        return nil;
    }
    
    CGImageRef imageRef = NULL;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    if ([response.MIMEType isEqualToString:@"image/png"]) {
        imageRef = CGImageCreateWithPNGDataProvider(dataProvider,  NULL, true, kCGRenderingIntentDefault);
    } else if ([response.MIMEType isEqualToString:@"image/jpeg"]) {
        imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
        
        if (imageRef) {
            CGColorSpaceRef imageColorSpace = CGImageGetColorSpace(imageRef);
            CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(imageColorSpace);
            
            // CGImageCreateWithJPEGDataProvider does not properly handle CMKY, so fall back to AFImageWithDataAtScale
            if (imageColorSpaceModel == kCGColorSpaceModelCMYK) {
                CGImageRelease(imageRef);
                imageRef = NULL;
            }
        }
    }
    
    CGDataProviderRelease(dataProvider);
    
    UIImage *image = AFImageWithDataAtScale(data, scale);
    if (!imageRef) {
        if (image.images || !image) {
            return image;
        }
        
        imageRef = CGImageCreateCopy([image CGImage]);
        if (!imageRef) {
            return nil;
        }
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    
    // (8/11/15): This maxmimum size requirement is a bit too small for our uses right now--it causes the downloaded
    // image to not be inflated and causes a lot of lag when scrolling through the UITableView. SDWebImage doesn't
    // even have this maximum size check so I thought it would be OK to increase the maxmimum size a bit
    
    // Used to be: if (width * height > 1024 * 1024 || bitsPerComponent > 8)
    if (width * height > 1536 * 1536 || bitsPerComponent > 8) {
        CGImageRelease(imageRef);
        
        return image;
    }
    
    // CGImageGetBytesPerRow() calculates incorrectly in iOS 5.0, so defer to CGBitmapContextCreate
    size_t bytesPerRow = 0;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB) {
        uint32_t alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
#pragma clang diagnostic pop
    }
    
    /**** START extra code *****/
    // Downscale the image if possible
//    NSLog(@"Given scale: %.1f", scale);
//    NSLog(@"Image size originally: %.1lu x %.1lu", width, height);
    if(!CGSizeEqualToSize(destinationSize, CGSizeZero))
    {
        if(width > destinationSize.width && height > destinationSize.height)
        {   
            width = destinationSize.width * scale;
            height = destinationSize.height * scale;
            
//            NSLog(@"   resizing the image to: %.1lu by %.1lu", width, height);
        }
//        else
//            NSLog(@"   keeping original size");
    }
    /***** END extra code ********/
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        CGImageRelease(imageRef);
        
        return image;
    }
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:scale orientation:image.imageOrientation];
    
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}


@implementation BEImageResponseSerializer

/** Override -init from AFImageResponseSerializer **/
- (instancetype)init
{
    self = [super init];
    if(self)
    {
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        _destinationSize = CGSizeZero;
#endif
    }
    
    return self;
}

/** Overrides same method in AFImageResponseSerializer **/
- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    if (self.automaticallyInflatesResponseImage) {
        return BEInflatedImageFromResponseWithDataAtScale((NSHTTPURLResponse *)response, data, self.imageScale, self.destinationSize);
    } else {
        return AFImageWithDataAtScale(data, self.imageScale);
    }
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    // Ensure that the image is set to it's correct pixel width and height
    NSBitmapImageRep *bitimage = [[NSBitmapImageRep alloc] initWithData:data];
    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize([bitimage pixelsWide], [bitimage pixelsHigh])];
    [image addRepresentation:bitimage];
    
    return image;
#endif
    
    return nil;
}

@end
