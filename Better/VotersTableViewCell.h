//
//  VotersTableViewCell.h
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEFadingImageView.h"

@interface VotersTableViewCell : UITableViewCell

/** The profile picture of the user */
@property (weak, nonatomic) IBOutlet BEFadingImageView *profilePictureView;

/** The username string of the user */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/** Icon for showing follower/non-follower status */
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
