//
//  VoterObject.h
//  Better
//
//  Created by Peter on 8/14/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoterObject : NSObject

/** Uniquely identifies a vote */
@property (nonatomic)                   int voteID;

/** User ID of the voter */
@property (nonatomic)                   int userID;

/** Username of the voter */
@property (strong, nonatomic)           NSString *username;

/** Whether or not this vote object is active (i.e. are we
 following the user of this vote object) */
@property (nonatomic, getter=isActive)  BOOL active;

/** Whether or not this vote object is currently changing its active state -- if true, we should not
 send another network request until it has finished changing its state */
@property (nonatomic, getter=isChangingActiveState) BOOL changingActiveState;

@end
