//
//  SelectedHashtagsFlowLayout.h
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//
//  The purpose of this class is to override the regular FlowLayout's behavior of adding more padding between
//  UICollectionView cells when it moves to the next line and the elements on the previous line have less total
//  width than the width of the CollectionView
//
//  Left-aligned is the goal
//
//  What it does by default:
//  |  aa   aa   aa  |
//  |      a   aaa   |
//  | .....          |
//
//  What it should do, for this application:
//  | aa aa aa       |
//  | a aaa          |
//  | .........      |

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface SelectedHashtagsFlowLayout : UICollectionViewFlowLayout

@end
