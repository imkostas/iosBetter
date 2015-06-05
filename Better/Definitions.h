//
//  Definitions.h
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#ifndef Better_Definitions_h
#define Better_Definitions_h

// Storyboard identifiers
#define STORYBOARD_ID_SEGUE_EMBED_INTRO @"embedPageViewController"

#define STORYBOARD_ID_INTROPAGE_TITLE @"introPageTitle"
#define STORYBOARD_ID_INTROPAGE_NOTITLE @"introPageNoTitle"

#define STORYBOARD_ID_FEED @"feedViewController"
#define STORYBOARD_ID_FEED_NAVIGATION @"feedViewControllerNav"
#define STORYBOARD_ID_SEGUE_EMBED_MENU @"embedMenu"
#define STORYBOARD_ID_SEGUE_EMBED_FILTER @"embedFilter"

// Screen width and height
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

// Drawer properties
#define RATIO_DRAWER_RELEASE_THRESHOLD_TO_WIDTH 2.5

// Gesture properties/thresholds
#define GESTURE_THRESHOLD_FAST_DRAWER 300

// Picker dimensions
#define HEIGHT_PICKER_TOPBAR 40
#define MARGIN_PICKER_DISMISSBTN_RIGHT 8

// Keyboard padding
#define PADDING_TOP_KEYBOARD 20

// Text field icon padding / size ratios
/**
 * The ratio of the text field's total height to the desired height of the text field's icon.
 * E.g. TextField height == 50 and ratio == 2 --> height of icon == 25
 */
#define RATIO_TEXTFIELD_ICON_TO_HEIGHT 2
#define PADDING_TEXTFIELD_ICON 16

// Colors
#define COLOR_NAVIGATION_TINT ([UIColor colorWithWhite:0.8 alpha:1.0])
#define COLOR_NAVIGATION_BAR ([UIColor colorWithWhite:0 alpha:0.1])
#define COLOR_BETTER ([UIColor colorWithRed:29/255.0 green:233/255.0 blue:182/255.0 alpha:1.0])
#define COLOR_BETTER_DARK ([UIColor colorWithRed:0 green:150/255.0 blue:136/255.0 alpha:1.0])
#define COLOR_BETTER_DARKER ([UIColor colorWithRed:0 green:0.3 blue:0.25 alpha:1.0])
#define COLOR_PICKER_BACKGROUND ([UIColor colorWithWhite:0.85 alpha:1.0])
#define COLOR_PICKER_TOPBAR ([UIColor colorWithWhite:0.97 alpha:1.0])
#define COLOR_PICKER_TRANSPARENCY ([UIColor colorWithWhite:0.2 alpha:0.5])
#define COLOR_LIGHT_LIGHT_GRAY ([UIColor colorWithWhite:0.96 alpha:1.0])

// Images
#define IMAGE_GENDER_FEMALE @"account_button_female_125dp"
#define IMAGE_GENDER_FEMALE_PRESSED @"account_button_female_pressed_125dp"
#define IMAGE_GENDER_MALE @"account_button_male_125dp"
#define IMAGE_GENDER_MALE_PRESSED @"account_button_male_pressed_125dp"

#define IMAGE_TUTORIAL_SHOES_DARK @"initial_tutorial_shoes_dark"
#define IMAGE_TUTORIAL_SHOES_SPOT @"initial_tutorial_shoes_spot"
#define IMAGE_TUTORIAL_POST @"initial_tutorial_post"
#define IMAGE_TUTORIAL_CROWN @"initial_tutorial_crown"

// Icons
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

// Animation properties
#define ANIM_DURATION_INTRO (500/1000.0) // converts to seconds
#define ANIM_DELAY_INTRO (300/1000.0)
#define ANIM_DURATION_PICKER (200/1000.0)
#define ANIM_DURATION_DRAWER_FULLSLIDE (250/1000.0)
#define ANIM_DURATION_CHANGE_VIEWCONTROLLER_TITLE (200/1000.0)

// Date picker tags (for each ui element needing it)
#define TAG_DATEPICKER_DOB 1

// (Regular) picker tags
#define TAG_PICKER_COUNTRY 1

// Gender
#define GENDER_UNDEFINED 0
#define GENDER_MALE 1
#define GENDER_FEMALE 2

#endif
