//
//  ThreeDotTableViewCell.h
//  Better
//
//  Created by Peter on 8/5/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"

@interface ThreeDotTableViewCell : UITableViewCell

/** Text label on the left of the cell */
@property (weak, nonatomic) IBOutlet UILabel *label;
//@property (strong, nonatomic) UILabel *label;

/** Icon on the right of the cell */
@property (weak, nonatomic) IBOutlet UIImageView *icon;
//@property (strong, nonatomic) UIImageView *icon;

@end
