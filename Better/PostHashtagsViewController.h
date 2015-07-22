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
#import "BEAddTagButton.h"
#import "HashtagCellDeletable.h"
#import "HashtagCellNoDelete.h"
#import "SelectedHashtagsFlowLayout.h"
#import "SuggestedTag.h"

@interface PostHashtagsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HashtagCellDeletableDelegate, BEAddTagButtonDelegate>

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

// Outlet to "Tap to Add Tags" button
@property (weak, nonatomic) IBOutlet BEAddTagButton *addTagButton;

// Outlets to the upper and lower collection views
@property (weak, nonatomic) IBOutlet UICollectionView *selectedTagsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *suggestedTagsCollectionView;

// Constraint for the upper collection view's height
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedTagsCollectionViewHeight;

// Actions for "Tap to Add Tags" button and "Post Your Question" button
- (IBAction)pressedAddTagButton:(id)sender;
- (IBAction)pressedPostButton:(id)sender;
@end
