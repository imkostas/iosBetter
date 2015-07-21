//
//  HashtagCellNoDelete.h
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BELabel.h"

@interface HashtagCellNoDelete : UICollectionViewCell

// Outlet to the hashtag label of this cell
@property (weak, nonatomic) IBOutlet BELabel *hashtagLabel;

@end
