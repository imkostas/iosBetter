////
////  BELabelFast.m
////  Better
////
////  Created by Peter on 7/30/15.
////  Copyright (c) 2015 Company. All rights reserved.
////
//
//#import "BELabelFast.h"
//
//@implementation BELabelFast
//
//// Override the default implementation
//- (void)drawTextInRect:(CGRect)rect
//{
//    // Get the current graphics context (the UILabel's graphics context)
//    CGContextRef graphics = UIGraphicsGetCurrentContext();
//    
//    // The coordinates are flipped, so flip them back
//    CGContextTranslateCTM(graphics, 0, CGRectGetHeight(rect));
//    CGContextScaleCTM(graphics, 1, -1); // Flip upside down
//    
//    // Set text matrix (is this necessary?)
//    CGContextSetTextMatrix(graphics, CGAffineTransformIdentity);
//    
//    // Get the UILabel's attributed string and string length (whenever you set the `text` or `attributedText`
//    // properties on a UILabel, the UILabel sets the other property to the corresponding text)
//    CFAttributedStringRef attrString = (__bridge CFAttributedStringRef)[super attributedText];
//
//    // Create the framesetter
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
//    
//    // Rectangular bounds for the text (make it exactly match `rect` parameter)
//    // The CGFLOAT_MAX parameter in cgsizemake allows the text to grow
//    CGSize suggestedTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(rect.size.width, CGFLOAT_MAX), NULL);
//    
//    NSLog(@"suggested size: %@", [NSValue valueWithCGSize:suggestedTextSize]);
////    NSLog(@"size of rect: %@", [NSValue valueWithCGSize:rect.size]);
//    
//    // Get a rectangular path from this suggested size -- I'm using ceilf(..) because sometimes, the `rect` parameter
//    // can return values that are not integers (i.e. for two lines of hashtags, it gives 35.5, which is just
//    // short enough to cut off the bottom
//    CGRect textBoundsRect = CGRectMake(0, 0, suggestedTextSize.width, suggestedTextSize.height/*ceilf(rect.size.width), ceilf(rect.size.height)*/);
//    CGPathRef textBoundsPath = CGPathCreateWithRect(textBoundsRect, NULL);
//    
//    // Create frame from framesetter
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), textBoundsPath, NULL);
//    
//    CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
//    CTFrameRef frame2 = CTFramesetterCreateFrame(framesetter, visibleRange, textBoundsPath, NULL);
//    NSLog(@"visible range: %ld, %ld", visibleRange.location, visibleRange.length);
//    
//    // Draw the frame
//    CTFrameDraw(frame2, graphics);
//    
//    // Release
//    CFRelease(textBoundsPath);
//    CFRelease(frame);
//    CFRelease(frame2);
//    CFRelease(framesetter);
//}
//
//@end
