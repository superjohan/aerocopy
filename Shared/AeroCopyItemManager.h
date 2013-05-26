//
//  AeroCopyItemManager.h
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kAeroCopySavedNotification;
extern NSString * const kAeroCopyUpdateddNotification;
extern NSString * const kAeroCopyUserInfoItemKey;

@class AeroCopyItem;

@interface AeroCopyItemManager : NSObject

- (void)loadItems;
- (void)checkPasteboardForNewItem;
- (AeroCopyItem *)itemFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryFromItem:(AeroCopyItem *)item;
- (NSArray *)sortedItems;

// Mac-only methods
#if __MAC_OS_X_VERSION_MIN_REQUIRED
- (BOOL)clipboardCanBeSaved;
#endif

@end
