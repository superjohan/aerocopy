//
//  AeroCopyAppDelegate.m
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//


#import "AeroCopyAppDelegate.h"
#import "AeroCopyMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AeroCopyItemManager.h"
#import "AeroCopyConstants.h"

@interface AeroCopyAppDelegate ()
@property (nonatomic, strong) AeroCopyItemManager *itemManager;
@end

@implementation AeroCopyAppDelegate

@synthesize window = mWindow;
@synthesize mainViewController = mMainViewController;
@synthesize itemManager = mItemManager;

#pragma mark - Public

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	self.itemManager = [[AeroCopyItemManager alloc] init];
	[self.itemManager loadItems];
	
	self.mainViewController = [[AeroCopyMainViewController alloc] initWithNibName:@"AeroCopyMainViewController" bundle:nil];
	self.mainViewController.itemManager = self.itemManager;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
	navController.navigationBarHidden = YES;
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[self.itemManager checkPasteboardForNewItem];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
