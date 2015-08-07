//
//  ThreeDotObject.h
//  Better
//
//  Created by Peter on 8/7/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An enumeration used in the type property of a ThreeDotObject to identify its purpose. */
typedef NS_ENUM(NSUInteger, ThreeDotObjectType) {
    /** A cell representing the "Voters" row of the UITableView */
    ThreeDotObjectTypeVoters,
    /** A cell representing the "Favorite Post" row of the UITableView */
    ThreeDotObjectTypeFavoritePost,
    /** A cell representing the <USERNAME HERE> row of the UITableView */
    ThreeDotObjectTypeUsername,
    /** A cell representing a hashtag row of the UITableView */
    ThreeDotObjectTypeHashtag,
    /** A cell representing the "Report Misuse" row of the UITableView */
    ThreeDotObjectTypeReportMisuse
};

@interface ThreeDotObject : NSObject

/** The type of this ThreeDotObject */
@property (nonatomic) ThreeDotObjectType type;

/** An identification number for this ThreeDotObject, typically set to a hashtag ID number */
@property (nonatomic) int objectID;

/** The title of the ThreeDotObject */
@property (strong, nonatomic) NSString *title;

/** The attributed title of the ThreeDotObject, used for hashtags */
@property (strong, nonatomic) NSAttributedString *attributedTitle;

/** A flag determining if this ThreeDotObject is active (if applicable). Defaults to FALSE */
@property (nonatomic, getter=isActive) BOOL active;


/** Custom initalizer */
- (instancetype)initWithType:(ThreeDotObjectType)type;

@end
