//
//  PostHashtagsViewController.h
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostHashtagsViewController : UIViewController

// Hotspot hashtags (set by previous view controller)
@property (strong, nonatomic) NSString *hotspotHashtagA;
@property (strong, nonatomic) NSString *hotspotHashtagB;

// Cropped images (set by previous view controller)
@property (strong, nonatomic) UIImage *imageA;
@property (strong, nonatomic) UIImage *imageB;

@end
