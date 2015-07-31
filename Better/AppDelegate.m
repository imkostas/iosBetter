//
//  AppDelegate.m
//  Better
//
//  Created by Peter on 5/19/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
    
    // Set default keychain accessibility mode (keychain items accessible only when the device is unlocked)
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
	
	// Set colors
//	[[UINavigationBar appearance] setBarTintColor:COLOR_NAVIGATION_BAR];
//	[[UINavigationBar appearance] setTintColor:COLOR_NAVIGATION_TINT];
    
    // Get some Raleway fonts
    UIFont *ralewaySemiboldNavBar = [UIFont fontWithName:FONT_RALEWAY_SEMIBOLD size:FONT_SIZE_NAVIGATION_BAR];
    UIFont *ralewayMediumNavBar = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:FONT_SIZE_NAVIGATION_BAR];
    UIFont *ralewayTabBarItem = [UIFont fontWithName:FONT_RALEWAY_MEDIUM size:([UIFont smallSystemFontSize] - 1)];
    
    // Navigation bar title font (the title in the center)
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:ralewaySemiboldNavBar}];
    
    // Navigation bar button items fonts (i.e. back button, Done button, other buttons)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:ralewayMediumNavBar} forState:UIControlStateNormal];
    
    // Set ImagePicker navigation bar items back to normal
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:nil forState:UIControlStateNormal];
    
    // Color of the dots at the bottom of a UIPageViewController
	[[UIPageControl appearance] setCurrentPageIndicatorTintColor:COLOR_BETTER];
    
    // Font of UITabBarItems in a UITabBarController (e.g. in the Terms of Service / Privacy Policy tab controller)
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:ralewayTabBarItem} forState:UIControlStateNormal];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
