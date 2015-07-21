//
//  HashtagCellDeletable.h
//  Better
//
//  Created by Peter on 7/21/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HashtagCellDeletable;

@protocol HashtagCellDeletableDelegate <NSObject>
@optional
/**
 Tells the delegate that the delete button of this hashtag cell has been pressed
 */
- (void)deleteButtonWasPressedForHashtagCell:(HashtagCellDeletable *)cell;

@end

@interface HashtagCellDeletable : UICollectionViewCell

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *hashtagLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

// Called when the "X" button is tapped
- (IBAction)pressedDeleteButton:(id)sender;

// Delegate to notify when the "X" button is tapped
@property (weak, nonatomic) id<HashtagCellDeletableDelegate> delegate;

@end
