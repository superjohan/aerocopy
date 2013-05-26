//
//  AeroCopyItemsViewController.m
//  aerocopy-mac
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyItemsViewController.h"
#import "AeroCopyItemManager.h"
#import "AeroCopyItem.h"
#import "RegexKitLite.h"
#import "AeroCopyAppDelegate.h"

@interface AeroCopyItemsViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AeroCopyItemsViewController

@synthesize itemManager = _itemManager;
@synthesize webView = _webView;
@synthesize dateFormatter = _dateFormatter;
@synthesize saveButton = _saveButton;
@synthesize menuButton = _menuButton;

#pragma mark - Private

- (NSString *)ae_HTMLFromString:(NSString *)string
{
	NSArray *urls = [string componentsMatchedByRegex:@"\\bhttps?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"];
	__block NSString *htmlString = [string copy];
	[urls enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger index, BOOL *stop) {
		htmlString = [htmlString stringByReplacingOccurrencesOfString:urlString withString:[NSString stringWithFormat:@"<a href=\"%@\">%@</a>", urlString, urlString]];
	}];
	
	return htmlString;
}

- (void)ae_updateWebViewContent
{
	NSString *htmlString = @"<html><style type=\"text/css\">body { font-family: HelveticaNeue-Light; font-size: 14px; color: #111; line-height: 21px; } .date { margin-top: -8px; font-family: HelveticaNeue; font-size: 11px; } hr { height: 1px; width: 80%; color: #888; background-color: #888; border: 0; } a { color: #fb6b1b; text-decoration: none; }</style><body>";
	NSArray *items = [self.itemManager sortedItems];
	for (AeroCopyItem *item in items)
	{
		NSString *itemHTML = [self ae_HTMLFromString:item.text];
		htmlString = [htmlString stringByAppendingFormat:@"<p class=\"text\">%@</p><p class=\"date\">%@</p>", itemHTML, [self.dateFormatter stringFromDate:item.date]];
		
		if ([items indexOfObject:item] < items.count - 1)
			htmlString = [htmlString stringByAppendingString:@"<hr>"];
	}
	
	[self.webView.mainFrame loadHTMLString:htmlString baseURL:nil];
}

- (void)ae_updateNotification:(NSNotification *)notification
{
	[self ae_updateWebViewContent];
}

- (void)ae_aboutItemClicked:(id)sender
{
	AeroCopyAppDelegate *ad = (AeroCopyAppDelegate *)[[NSApplication sharedApplication] delegate];
	[ad showAbout];
}

- (void)ae_quitItemClicked:(id)sender
{
	[NSApp terminate:self];
}

- (void)ae_configureMenu
{
	[self.menuButton removeAllItems];
	
	NSMenu *menu = [NSMenu new];
	NSMenuItem *thing = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
	thing.image = [NSImage imageNamed:@"settings.png"];
	[menu addItem:thing];
	[[menu addItemWithTitle:NSLocalizedString(@"About", nil) action:@selector(ae_aboutItemClicked:) keyEquivalent:@""] setTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];
	[[menu addItemWithTitle:NSLocalizedString(@"Quit", nil) action:@selector(ae_quitItemClicked:) keyEquivalent:@""] setTarget:self];
	self.menuButton.menu = menu;
}

#pragma mark - IBActions

- (IBAction)saveButtonClicked:(id)sender
{
	[self.itemManager checkPasteboardForNewItem];
}

#pragma mark - Public

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		self.dateFormatter = [[NSDateFormatter alloc] init];
		self.dateFormatter.dateStyle = NSDateFormatterFullStyle;
    }
    
    return self;
}

- (void)popoverWillShow
{
	self.webView.hidden = NO;
	self.webView.drawsBackground = NO;

	self.saveButton.enabled = [self.itemManager clipboardCanBeSaved];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ae_updateNotification:) name:kAeroCopySavedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ae_updateNotification:) name:kAeroCopyUpdateddNotification object:nil];

	[self ae_configureMenu];
	[self ae_updateWebViewContent];
}

- (void)popoverWillClose
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kAeroCopySavedNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kAeroCopyUpdateddNotification object:nil];
}

#pragma mark - WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
	if (request.URL.host == nil)
		[listener use];
	else
	{
		[listener ignore];
		[[NSWorkspace sharedWorkspace] openURL:request.URL];
	}
}

@end
