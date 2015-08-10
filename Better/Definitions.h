//
//  Definitions.h
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#ifndef Better_Definitions_h
#define Better_Definitions_h

// Enums
/**
 An integer that keeps track of the state of the image layout in a New Post
 */
typedef NS_ENUM(NSUInteger, LayoutState) {
    /** image A is fully shown, image B is hidden */
    LAYOUTSTATE_A_ONLY = 0,
    /** image A is on the left, image B is on the right */
    LAYOUTSTATE_LEFT_RIGHT = 1,
    /** image A is on the top, image B is on the bottom */
    LAYOUTSTATE_TOP_BOTTOM = 2
};

/**
 An integer that specifies the type of vote that a user has made on a particular post--there are three
 possibilities:
 (0) voted on hotspot A (a.k.a. hotspot one)
 (1) voted on hotspot B (a.k.a. hotspot two)
 (2) no vote
 */
enum VoteState {
    VOTE_HOTSPOT_A = 1,
    VOTE_HOTSPOT_B = 2,
    VOTE_NOVOTE = 3 // these number values correspond to the values recognized by the server API
};

/** Some strings */
#define STRING_VOTERS @"Voters"
#define STRING_FAVORITE_POST @"Favorite Post"
#define STRING_REPORT_MISUSE @"Report Misuse"

/** Specifies a certain kind of filter for the feed */
#define FEED_FILTER_EVERYTHING @""
#define FEED_FILTER_FAVORITETAGS @"favoritehashtag/"
#define FEED_FILTER_FOLLOWING @"following/"
#define FEED_FILTER_TRENDING @"trending/"

// Storyboard filenames
#define STORYBOARD_FILENAME_FEED @"Feed"
#define STORYBOARD_FILENAME_SETTINGS @"Settings"
#define STORYBOARD_FILENAME_CREATEPOST @"CreatePost"

// Storyboard identifiers
#define STORYBOARD_ID_SEGUE_EMBED_INTRO @"embedPageViewController"
#define STORYBOARD_ID_SEGUE_EMBED_MENU @"embedMenu"
#define STORYBOARD_ID_SEGUE_EMBED_FILTER @"embedFilter"
#define STORYBOARD_ID_SEGUE_EMBED_FEED_MAIN @"embedFeedTableViewController"

#define STORYBOARD_ID_INTROPAGE_TITLE @"introPageTitle"
#define STORYBOARD_ID_INTROPAGE_NOTITLE @"introPageNoTitle"

#define STORYBOARD_ID_SEGUE_UNWIND_TO_INTRO @"unwindToIntro"

    /*** Navigation controllers **/
    #define STORYBOARD_ID_MYRANKING_NAVIGATION @"myRankingNavigation"
    #define STORYBOARD_ID_SETTINGS_NAVIGATION @"settingsNavigation"
    #define STORYBOARD_ID_MYINFORMATION_NAVIGATION @"myInfoNavigation"
    #define STORYBOARD_ID_CREATEPOST_NAVIGATION @"createPostNavigation"

    /*** View controllers **/
    #define STORYBOARD_ID_FEED @"feedViewController"
    #define STORYBOARD_ID_MYRANKING @"myRankingViewController"
    #define STORYBOARD_ID_LEADERBOARD @"leaderboardViewController"
    #define STORYBOARD_ID_SEGUE_EMBED_RANKING @"embedMyRanking"
    #define STORYBOARD_ID_CREATEPOST_LAYOUT @"postLayoutViewController"

    /** Settings segues **/
    #define STORYBOARD_ID_SEGUE_SHOW_SETTINGS_MYACCOUNT @"showSettingsMyAccount"
    #define STORYBOARD_ID_SEGUE_SHOW_SETTINGS_NOTIFICATIONS @"showSettingsNotifications"
    #define STORYBOARD_ID_SEGUE_SHOW_SETTINGS_SUPPORT @"showSettingsSupport"

    /** Support segue **/
    #define STORYBOARD_ID_SEGUE_SHOW_SUPPORT_TERMSPRIVACY @"showSupportTermsPrivacy"

    /** Create Post segues **/
    #define STORYBOARD_ID_SEGUE_SHOW_HASHTAGS_SETUP @"showPostHashtags"

// Reuse identifiers
#define REUSE_ID_MYINFORMATION_TABLECELL @"myInfoTableViewCell"
#define REUSE_ID_BADGES_COLLECTION_CELL @"badgesCollectionViewCell"
#define REUSE_ID_LEADERBOARD_TABLECELL @"leaderboardTableViewCell"
#define REUSE_ID_HASHTAG_COLLECTION_CELL_DELETABLE @"hashtagCellDeletable"
#define REUSE_ID_HASHTAG_COLLECTION_CELL_NO_DELETE @"hashtagCellNoDelete"
#define REUSE_ID_THREE_DOT_TABLEVIEW_CELL @"threeDotTableViewCell"

// Nib filenames
#define NIB_NAME_HASHTAG_COLLECTION_CELL_DELETABLE @"HashtagCellDeletable"
#define NIB_NAME_HASHTAG_COLLECTION_CELL_NO_DELETE @"HashtagCellNoDelete"

// Screen width and height
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// BETextField height
#define HEIGHT_BETEXTFIELD 60

// Drawer properties
#define RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH 2.25

// Gesture properties/thresholds
#define GESTURE_THRESHOLD_FAST_DRAWER 300

// Picker dimensions
#define HEIGHT_PICKER_TOPBAR 40
#define MARGIN_PICKER_DISMISSBTN_RIGHT 8

// Keyboard padding
#define PADDING_TOP_KEYBOARD 20

// My Ranking rank bar properties
#define PADDING_MYRANKING_BETWEEN_SEGMENTS 3
#define HEIGHT_MYRANKING_SEGMENT_PERCENT_OF_VIEW_HEIGHT 0.35

// Text field icon padding / size ratios
/**
 * The ratio of the text field's total height to the desired height of the text field's icon.
 * E.g. TextField height == 50 and ratio == 2 --> height of icon == 25
 */
#define RATIO_TEXTFIELD_ICON_TO_HEIGHT 2
#define PADDING_TEXTFIELD_ICON 16

// Line spacing
#define LINE_SPACING_SPOTLIGHTS_HELPTEXT (-4)

// Hotspot size
#define WIDTH_HOTSPOT 100
#define HEIGHT_HOTSPOT 100

// Maximum number of characters in a user-submitted hashtag
#define MAX_LENGTH_HASHTAG 20
// Maximum number of hashtags possible to add in a post
#define MAX_NUMBER_OF_HASHTAGS 8

// UICollectionView layout constants
#define EDGEINSETS_SELECTED_TAGS_COLLECTIONVIEW UIEdgeInsetsMake(16,16,16,16)
#define EDGEINSETS_SUGGESTED_TAGS_COLLECTIONVIEW UIEdgeInsetsMake(8,16,8,16)
#define MINIMUM_INTERITEM_SPACING_SELECTED_TAGS_COLLECTIONVIEW 8

// 3-dot menu tableviewcell dimensions
#define HEIGHT_3DOT_MENU_ROW 50

/**** Feed cells ****/
#define MARGIN_FEEDCELL_SHADOWVIEW 8

// Colors
#define COLOR_NAVIGATION_TINT [UIColor colorWithWhite:0.8 alpha:1.0]
#define COLOR_NAVIGATION_BAR [UIColor colorWithWhite:0 alpha:0.1]
#define COLOR_BETTER [UIColor colorWithRed:29/255.0 green:233/255.0 blue:182/255.0 alpha:1.0]
#define COLOR_BETTER_DARK [UIColor colorWithRed:0 green:150/255.0 blue:136/255.0 alpha:1.0]
#define COLOR_BETTER_DARKER [UIColor colorWithRed:0 green:0.3 blue:0.25 alpha:1.0]
#define COLOR_PICKER_BACKGROUND [UIColor colorWithWhite:0.85 alpha:1.0]
#define COLOR_PICKER_TOPBAR [UIColor colorWithWhite:0.97 alpha:1.0]
#define COLOR_PICKER_TRANSPARENCY [UIColor colorWithWhite:0.2 alpha:0.5]
#define COLOR_LIGHT_LIGHT_GRAY [UIColor colorWithWhite:0.96 alpha:1.0]
#define COLOR_LIGHTER_GRAY [UIColor colorWithWhite:0.98 alpha:1.0]
#define COLOR_LIGHT_GRAY [UIColor colorWithWhite:0.62 alpha:1.0]
#define COLOR_GRAY_FEED [UIColor colorWithRed:0.82 green:0.82 blue:0.83 alpha:1.0]

#define COLOR_GRAY [UIColor colorWithWhite:0.85 alpha:1.0]
#define COLOR_POST_DIVIDER [UIColor colorWithWhite:0.62 alpha:1.0]
#define COLOR_FEED_HEADERTEXT [UIColor colorWithWhite:0.46 alpha:1.0]
#define COLOR_FEED_HASHTAGS_STOCK [UIColor colorWithWhite:0.5 alpha:1.0]
#define COLOR_FEED_HASHTAGS_CUSTOM [UIColor blackColor]

#define COLOR_CREATEPOST_LAYOUT_SWITCHER [UIColor colorWithWhite:66/255. alpha:1.0] // 0x42
#define COLOR_CREATEPOST_HASH_CHARACTER [UIColor colorWithWhite:0.75 alpha:1.0]

// Alpha values
#define ALPHA_FEED_OVERLAY 0.65
#define ALPHA_PROFILE_PANEL_OVERLAY 0.69

// Images
#define IMAGE_GENDER_FEMALE @"account_button_female_125dp"
#define IMAGE_GENDER_FEMALE_PRESSED @"account_button_female_pressed_125dp"
#define IMAGE_GENDER_MALE @"account_button_male_125dp"
#define IMAGE_GENDER_MALE_PRESSED @"account_button_male_pressed_125dp"

#define IMAGE_TUTORIAL_SHOES_DARK @"initial_tutorial_shoes_dark"
#define IMAGE_TUTORIAL_SHOES_SPOT @"initial_tutorial_shoes_spot"
#define IMAGE_TUTORIAL_POST @"initial_tutorial_post"
#define IMAGE_TUTORIAL_CROWN @"initial_tutorial_crown"

#define IMAGE_EMPTY_PROFILE_PANEL @"account_profile_panel_empty"
#define IMAGE_EMPTY_PROFILE_PICTURE_FEMALE @"blank_profile_female_noalpha"
#define IMAGE_EMPTY_PROFILE_PICTURE_MALE @"blank_profile_male_noalpha"

#define IMAGE_PIXEL_TRANSPARENT @"TransparentPixel"
#define IMAGE_PIXEL_COLOR_BETTER_DARK @"Color_better_dark"

// Badges:
#define IMAGE_BADGE_DEFAULT @"badge_default"

#define IMAGE_BADGE_ADMIRER_BRONZE @"badge_bronze_admirer"
#define IMAGE_BADGE_ADMIRER_SILVER @"badge_silver_admirer"
#define IMAGE_BADGE_ADMIRER_GOLD @"badge_gold_admirer"

#define IMAGE_BADGE_ADVENTURER_BRONZE @"badge_bronze_adventurer"
#define IMAGE_BADGE_ADVENTURER_SILVER @"badge_silver_adventurer"
#define IMAGE_BADGE_ADVENTURER_GOLD @"badge_gold_adventurer"

#define IMAGE_BADGE_CELEBRITY_BRONZE @"badge_bronze_celebrity"
#define IMAGE_BADGE_CELEBRITY_SILVER @"badge_silver_celebrity"
#define IMAGE_BADGE_CELEBRITY_GOLD @"badge_gold_celebrity"

#define IMAGE_BADGE_IDOL_BRONZE @"badge_bronze_idol"
#define IMAGE_BADGE_IDOL_SILVER @"badge_silver_idol"
//#define IMAGE_BADGE_IDOL_GOLD @"badge_gold_idol" // Mysteriously missing asset.....

#define IMAGE_BADGE_ROLEMODEL_BRONZE @"badge_bronze_rolemodel"
#define IMAGE_BADGE_ROLEMODEL_SILVER @"badge_silver_rolemodel"
#define IMAGE_BADGE_ROLEMODEL_GOLD @"badge_gold_rolemodel"

#define IMAGE_BADGE_TASTEMAKER_BRONZE @"badge_bronze_tastemaker"
#define IMAGE_BADGE_TASTEMAKER_SILVER @"badge_silver_tastemaker"
#define IMAGE_BADGE_TASTEMAKER_GOLD @"badge_gold_tastemaker"

// Posting process
#define IMAGE_POSTING_HOTSPOT_UNTAGGED @"posting_hotspot_untagged"
#define IMAGE_POSTING_HOTSPOT_TAGGED @"posting_hotspot_tagged"

/*** Icons ***/
// Profile:
#define ICON_ACCOUNT @"ic_account_circle_grey600_24dp"
#define ICON_HTTPS @"ic_https_grey600_24dp"
#define ICON_EMAIL @"ic_email_grey600_24dp"
#define ICON_EVENT @"ic_event_note_grey600_24dp"
#define ICON_FLAG @"ic_flag_grey600_24dp"
#define ICON_VISIBILITY_OFF @"ic_visibility_off_grey600_24dp"
#define ICON_VISIBILITY_ON @"ic_visibility_on_green_24dp"
#define ICON_TAKEPICTURE @"ic_cam_account_white_116dp"

#define ICON_MENU @"ic_menu_green900_24dp"
#define ICON_FILTER @"ic_filter_list_green900_24dp"

// Crown:
#define ICON_CROWN_UNFILLED @"ic_better_crown_38dp"
#define ICON_CROWN_FILLED @"ic_crown_solid_30dp"

// Rank:
#define ICON_RANK_NEWBIE_WHITE @"ic_rank_newbie_white"
#define ICON_RANK_NEWBIE_GRAY @"ic_rank_newbie_gray"
#define ICON_RANK_MAINSTREAM_WHITE @"ic_rank_mainstream_white"
#define ICON_RANK_MAINSTREAM_GRAY @"ic_rank_mainstream_gray"
#define ICON_RANK_TRAILBLAZER_WHITE @"ic_rank_trailblazer_white"
#define ICON_RANK_TRAILBLAZER_GRAY @"ic_rank_trailblazer_gray"
#define ICON_RANK_TRENDSETTER_WHITE @"ic_rank_trendsetter_white"
#define ICON_RANK_TRENDSETTER_GRAY @"ic_rank_trendsetter_gray"
#define ICON_RANK_CROWNED_WHITE @"ic_rank_crowned_white"
#define ICON_RANK_CROWNED_GRAY @"ic_rank_crowned_gray"

// Rank table view:
#define ICON_CHECKMARK @"ic_check_grey600_18dp"
#define ICON_PORTRAIT @"ic_portrait_grey600_24dp"
#define ICON_FAVORITE_OUTLINE @"ic_favorite_outline_grey600_24dp"
#define ICON_FAVORITE_OUTLINE_LIGHT @"ic_favorite_light"
#define ICON_FAVORITED @"ic_favorite_filled"
#define ICON_PERSON_ADD @"ic_person_add_grey_24dp"
#define ICON_PERSON_ADDED @"icon_person_added"

// General icons
#define ICON_PLUS @"Plus"

// Posting processs
#define ICON_POSTLAYOUT_SINGLE_DARK @"post_single_image_gray"
#define ICON_POSTLAYOUT_SINGLE_LIGHT @"post_single_image_white"
#define ICON_POSTLAYOUT_LEFTRIGHT_DARK @"post_left_right_gray"
#define ICON_POSTLAYOUT_LEFTRIGHT_LIGHT @"post_left_right_white"
#define ICON_POSTLAYOUT_TOPBOTTOM_DARK @"post_top_bottom_gray"
#define ICON_POSTLAYOUT_TOPBOTTOM_LIGHT @"post_top_bottom_white"

#define ICON_WARNING @"icon_warning"

// Animation properties
#define ANIM_DURATION_INTRO (500/1000.0) // converts to seconds
#define ANIM_DELAY_INTRO (300/1000.0)
#define ANIM_DURATION_PICKER (250/1000.0)
#define ANIM_DURATION_DRAWER_FULLSLIDE (285/1000.0)
#define ANIM_DURATION_CHANGE_VIEWCONTROLLER_TITLE (200/1000.0)
#define ANIM_DURATION_CHANGE_DRAWER_SIZE (200/1000.0)
#define ANIM_DURATION_ALERT_SHOW (200/1000.0)
#define ANIM_DURATION_ALERT_HIDE (250/1000.0)
#define ANIM_DURATION_SEGMENTED_CONTROL_SWITCH (150/1000.0)
#define ANIM_DURATION_POST_LAYOUT_CHANGE (300/1000.0)
#define ANIM_DURATION_POST_FADE_IMAGE (300/1000.0)
#define ANIM_DURATION_3DOT_MENU_PRESENT 0.5f
#define ANIM_DURATION_3DOT_MENU_TABLEVIEW 0.5f

// Date picker tags (for each ui element needing it)
#define TAG_DATEPICKER_DOB 1

// (Regular) picker tags
#define TAG_PICKER_COUNTRY 1

// Gender
// These have to match the values returned by the API (specifically the first character of what is returned for
// the "gender" key)
#define GENDER_UNDEFINED 0
#define GENDER_MALE '2' // API returns a string: "2"
#define GENDER_FEMALE '1'

// Rank levels
#define RANK_NORANK 0
#define RANK_NOOB 1
#define RANK_MAINSTREAM 2
#define RANK_TRAILBLAZER 3
#define RANK_TRENDSETTER 4
#define RANK_CROWNED 5

// Font names
#define FONT_RALEWAY_MEDIUM @"Raleway-Medium"
#define FONT_RALEWAY_BOLD @"Raleway-Bold"
#define FONT_RALEWAY_SEMIBOLD @"Raleway-SemiBold"
#define FONT_SIZE_SEGMENTED_CONTROL [UIFont systemFontSize]
#define FONT_SIZE_NAVIGATION_BAR 17
#define FONT_SIZE_HASHTAG_ADDING_TAGS 15
#define FONT_SIZE_FEEDCELL_HASHTAG_LABEL 15

// From organic parking
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
