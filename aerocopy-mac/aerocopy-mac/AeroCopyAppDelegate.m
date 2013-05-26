//
//  AeroCopyAppDelegate.m
//  aerocopy-mac
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyAppDelegate.h"
#import "AeroCopyItemsViewController.h"
#import "AeroCopyItemManager.h"
#import "StatusItemView.h"

@interface AeroCopyAppDelegate ()
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) AeroCopyItemManager *itemManager;
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) AeroCopyItemsViewController *itemsViewController;
@property (nonatomic, strong) NSEvent *popoverTransiencyMonitor;
@end

@implementation AeroCopyAppDelegate

@synthesize statusItem = _statusItem;
@synthesize itemManager = _itemManager;
@synthesize popover = _popover;
@synthesize itemsViewController = _itemsViewController;
@synthesize popoverTransiencyMonitor = _popoverTransiencyMonitor;

#pragma mark - Private

- (void)ae_closePopover:(id)sender
{
	if (self.popoverTransiencyMonitor != nil)
	{
		[NSEvent removeMonitor:self.popoverTransiencyMonitor];
		self.popoverTransiencyMonitor = nil;
	}

	[self.popover close];
}

#pragma mark - Public

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSImage *itemImage = [NSImage imageNamed:@"menubaricon.png"];
	itemImage.size = NSMakeSize(itemImage.size.width, itemImage.size.height);
	StatusItemView *view = [[StatusItemView alloc] initWithFrame:NSMakeRect(0, 0, itemImage.size.width, itemImage.size.height)];
	view.owner = self;
	view.image = itemImage;

	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	self.statusItem.highlightMode = YES;
	[self.statusItem setView:view];

	self.itemManager = [[AeroCopyItemManager alloc] init];
	[self.itemManager loadItems];
}

- (void)itemClicked:(id)sender
{
	if ( ! [sender isKindOfClass:[StatusItemView class]])
		return;
	
	if (self.itemsViewController != nil)
	{
		[self ae_closePopover:sender];
		return;
	}
	
	StatusItemView *view = (StatusItemView *)sender;
	
	self.popover = [[NSPopover alloc] init];
	self.popover.behavior = NSPopoverBehaviorTransient;
	self.popover.appearance = NSPopoverAppearanceMinimal;
	self.itemsViewController = [[AeroCopyItemsViewController alloc] initWithNibName:@"AeroCopyItemsViewController" bundle:nil];
	self.itemsViewController.itemManager = self.itemManager;
	self.popover.contentViewController = self.itemsViewController;
	self.popover.delegate = self;
	[self.popover showRelativeToRect:view.frame ofView:view preferredEdge:NSMinYEdge];
	
	if (self.popoverTransiencyMonitor == nil)
		self.popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask | NSRightMouseDownMask | NSKeyDownMask handler:^(NSEvent *event) {
			[self ae_closePopover:sender];
		}];
}

- (void)showAbout
{
	[NSApp orderFrontStandardAboutPanel:self];
}

#pragma mark - NSPopoverDelegate

- (void)popoverWillShow:(NSNotification *)notification
{
	[self.itemsViewController popoverWillShow];
}

- (void)popoverDidClose:(NSNotification *)notification
{
	self.itemsViewController = nil;
}

- (void)popoverWillClose:(NSNotification *)notification
{
	[self.itemsViewController popoverWillClose];
}

@end
