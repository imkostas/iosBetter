//
//  BadgesCollectionViewCell.h
//  Better
//
//  Created by Peter on 6/22/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgesCollectionViewCell : UICollectionViewCell

// UI elements for a badge
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;
@property (weak, nonatomic) IBOutlet UILabel *badgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *badgeStatus;


@end
