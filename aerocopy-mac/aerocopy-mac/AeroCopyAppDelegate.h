//
//  AeroCopyAppDelegate.h
//  aerocopy-mac
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AeroCopyAppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate>

- (void)itemClicked:(id)sender;
- (void)showAbout;

@end
