//
//  AeroCopyItemManager.m
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyItemManager.h"
#import "AeroCopyItem.h"

NSString * const kCloudItemsKey = @"items";
NSString * const kAeroCopySavedNotification = @"kAeroCopySavedNotification";
NSString * const kAeroCopyUpdateddNotification = @"kAeroCopyUpdateddNotification";
NSString * const kAeroCopyItemDateKey = @"kAeroCopyItemDateKey";
NSString * const kAeroCopyItemTextKey = @"kAeroCopyItemTextKey";
NSString * const kAeroCopyUserInfoItemKey = @"item";

const NSInteger kMaximumItemCount = 50;
const NSInteger kMaximumItemLength = 300;

@interface AeroCopyItemManager ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation AeroCopyItemManager

@synthesize items = _items;

#pragma mark - Private

- (NSMutableArray *)ae_itemsAsDictionaries
{
	NSMutableArray *items = [NSMutableArray array];
	for (AeroCopyItem *item in self.items)
		[items addObject:[self dictionaryFromItem:item]];
	
	return items;
}

- (NSMutableArray *)ae_itemsFromDictionaryArray:(NSArray *)itemDictionaries
{
	NSMutableArray *items = [NSMutableArray array];
	for (NSDictionary *dict in itemDictionaries)
		[items addObject:[self itemFromDictionary:dict]];
	
	return items;
}

- (void)ae_setLocalAndCloudObject:(id)obj forKey:(id)key
{
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSUbiquitousKeyValueStore defaultStore] setObject:obj forKey:key];
	BOOL success = [[NSUbiquitousKeyValueStore defaultStore] synchronize]; // FIXME: *must* have error checking here
	
	if (success)
		AEDLOG_DEBUG(@"saved successfully");
	else
		AEDLOG_DEBUG(@"saving failed");
}

- (void)ae_saveItems
{
	if ([self.items count] > kMaximumItemCount)
		self.items = [[[self sortedItems] subarrayWithRange:NSMakeRange(0, kMaximumItemCount)] mutableCopy];

	[self ae_setLocalAndCloudObject:[self ae_itemsAsDictionaries] forKey:kCloudItemsKey];
}

- (void)ae_mergeItemsAndUpdate:(NSMutableArray *)updatedItems
{
	NSMutableArray *itemsNotInModel = [NSMutableArray array];
	for (AeroCopyItem *item in updatedItems)
	{
		BOOL exists = NO;
		for (AeroCopyItem *oldItem in self.items)
		{
			if ([oldItem.text isEqualToString:item.text])
			{
				exists = YES;
				break;
			}
		}
		
		if ( ! exists)
			[itemsNotInModel addObject:item];
	}
	
	if (itemsNotInModel.count > 0)
	{
		AEDLOG_DEBUG(@"items to merge: %d", (int)itemsNotInModel.count);
		
		[self.items addObjectsFromArray:itemsNotInModel];
		[self.items sortUsingComparator:^(AeroCopyItem *i1, AeroCopyItem *i2) {
			return [i1.date compare:i2.date];
		}];
	
		[self ae_saveItems];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kAeroCopyUpdateddNotification object:nil];
	}
}

- (void)ae_cloudUpdated:(NSNotification *)notification
{
	NSArray *updatedItemDicts = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:kCloudItemsKey];
	NSMutableArray *updatedItems = [self ae_itemsFromDictionaryArray:updatedItemDicts];
	[self ae_mergeItemsAndUpdate:updatedItems];
}

- (void)ae_addItem:(NSString *)itemText
{
	if (self.items == nil)
		self.items = [[NSMutableArray alloc] init];
	
	if (itemText.length > kMaximumItemLength)
		itemText = [itemText substringToIndex:kMaximumItemLength];
	
	for (AeroCopyItem *existingItem in self.items)
	{
		if ([existingItem.text isEqualToString:itemText])
			return;
	}
	
	AeroCopyItem *item = [[AeroCopyItem alloc] initWithDate:[NSDate date] text:itemText];
	
	if ([self.items count] == 0)
		[self.items addObject:item];
	else
		[self.items insertObject:item atIndex:0]; // TODO: perform some kind of merge here
	
	[self ae_saveItems];

	[[NSNotificationCenter defaultCenter] postNotificationName:kAeroCopySavedNotification object:nil userInfo:[NSDictionary dictionaryWithObject:item forKey:@"item"]];
}

#pragma mark - Public

- (void)loadItems
{
	if ([[NSUbiquitousKeyValueStore defaultStore] synchronize])
		AEDLOG_DEBUG(@"iCloud is working");
	else
		AEDLOG_DEBUG(@"iCloud is not working");
	
	NSArray *localItemsAsDicts = [[NSUserDefaults standardUserDefaults] objectForKey:kCloudItemsKey];
	NSArray *cloudItemsAsDicts = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:kCloudItemsKey];
	self.items = [self ae_itemsFromDictionaryArray:localItemsAsDicts];
	[self ae_mergeItemsAndUpdate:[self ae_itemsFromDictionaryArray:cloudItemsAsDicts]];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ae_cloudUpdated:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
}

- (void)checkPasteboardForNewItem
{
	NSString *pasteboardItem = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED
	pasteboardItem = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
#elif __IPHONE_OS_VERSION_MIN_REQUIRED
	pasteboardItem = [[UIPasteboard generalPasteboard] string];
#endif
		
	if (pasteboardItem == nil)
		return;
	
	[self ae_addItem:pasteboardItem];
}

- (AeroCopyItem *)itemFromDictionary:(NSDictionary *)dictionary
{
	AeroCopyItem *item = [[AeroCopyItem alloc] init];
	item.date = [dictionary objectForKey:kAeroCopyItemDateKey];
	item.text = [dictionary objectForKey:kAeroCopyItemTextKey];
	
	return item;
}

- (NSDictionary *)dictionaryFromItem:(AeroCopyItem *)item
{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  item.date, kAeroCopyItemDateKey,
						  item.text, kAeroCopyItemTextKey,
						  nil];
	
	return dict;
}

- (NSArray *)sortedItems
{
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^(AeroCopyItem *item1, AeroCopyItem *item2) {
		return [item1.date compare:item2.date];
	}];
	
	return [self.items sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED
- (BOOL)clipboardCanBeSaved
{
	NSString *pasteboardItem = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
	
	return (pasteboardItem != nil);
}
#endif

@end
