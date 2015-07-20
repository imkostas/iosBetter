//
//  PostHashtagsViewController.h
//  Better
//
//  Created by Peter on 7/8/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "BELabel.h"

@interface PostHashtagsViewController : UIViewController

// Type of layout (single, left-right, or top-bottom)
@property (nonatomic) int imageLayout;

// Hotspot hashtags (set by previous view controller)
@property (strong, nonatomic) NSString *hotspotAHashtag;
@property (strong, nonatomic) NSString *hotspotBHashtag;

// Coordinates of hotspot centers
@property (nonatomic) CGPoint hotspotACoordinate;
@property (nonatomic) CGPoint hotspotBCoordinate;

// Cropped images (set by previous view controller)
@property (strong, nonatomic) UIImage *imageA;
@property (strong, nonatomic) UIImage *imageB;

// Outlet for the first line of 'instructions' (the only purpose of this is to be able to make it bold)
@property (weak, nonatomic) IBOutlet BELabel *addTagsLabel;
@end
