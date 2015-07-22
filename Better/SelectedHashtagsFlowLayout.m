//
//  SelectedHashtagsFlowLayout.m
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "SelectedHashtagsFlowLayout.h"

@implementation SelectedHashtagsFlowLayout

// Override super's implementation
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // Retrieve the values that the superclass would calculate
    NSArray *existingAttrs = [super layoutAttributesForElementsInRect:rect];
    
    // Get the insets and inter-item spacing from the delegate
    UIEdgeInsets insets = EDGEINSETS_SELECTED_TAGS_COLLECTIONVIEW;
    CGFloat minInteritemSpacing = MINIMUM_INTERITEM_SPACING_SELECTED_TAGS_COLLECTIONVIEW;

    // Initial values
    CGFloat currentCenterY = [[existingAttrs firstObject] center].y;
    CGFloat currentLeft = insets.left;

    // Loop through the array of layout attributes
    for(UICollectionViewLayoutAttributes *attrs in existingAttrs)
    {
        // Are we still on the same row?
        if([attrs center].y != currentCenterY) // Same row
        {
            currentCenterY = [attrs center].y;
            currentLeft = insets.left;
        }

        // Get current frame, set new origin.x
        CGRect newFrame = [attrs frame];
        newFrame.origin.x = currentLeft;

        // Apply new left side (origin.x)
        [attrs setFrame:newFrame];

        // Shift to next origin.x
        currentLeft += CGRectGetWidth(newFrame) + minInteritemSpacing;
    }

    return existingAttrs;
}

//- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
//{
//    CGSize frame = [[self collectionView] contentSize];
//}
//
//- (void)finalizeCollectionViewUpdates
//{
//    CGSize frame = [[self collectionView] contentSize];
//}

@end
