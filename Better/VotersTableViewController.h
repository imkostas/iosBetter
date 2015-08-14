//
//  Voters.h
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Definitions.h"
#import "VotersDataController.h"
#import "VotersTableViewCell.h"

@interface VotersTableViewController : UITableViewController <VotersDataControllerDelegate>

/** My datacontroller */
@property (strong, nonatomic) VotersDataController *dataController;

/** Custom initializer (use this) */
- (instancetype)initWithPostObject:(PostObject *)postObject;

@end
