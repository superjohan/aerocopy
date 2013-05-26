//
//  AeroCopyAppDelegate.h
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AeroCopyMainViewController;

@interface AeroCopyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AeroCopyMainViewController *mainViewController;

@end
