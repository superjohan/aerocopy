//
//  AeroCopyMainViewController.m
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyMainViewController.h"
#import "AeroCopyItemManager.h"
#import "AeroCopyItem.h"
#import "AEDNSArrayAdditions.h"
#import "AEDCGHelpers.h"
#import "AeroCopyDetailView.h"
#import "AeroCopyConstants.h"
#import "TutorialView.h"
#import "SavedNotificationView.h"
#import "AEDUIViewAdditions.h"

@interface AeroCopyMainViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *latestPasteboardItem;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AeroCopyMainViewController

@synthesize tableView = _tableView;
@synthesize items = _items;
@synthesize latestPasteboardItem = _latestPasteboardItem;
@synthesize itemManager = _itemManager;
@synthesize dateFormatter = _dateFormatter;
@synthesize detailView = _detailView;

#pragma mark - Private

- (void)ae_showSavedNotificationInCellWithIndex:(NSInteger)index
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
	SavedNotificationView *savedView = [[SavedNotificationView alloc] initWithFrame:cell.bounds];
	[savedView setDefaultRoundedCorners];
	[cell addSubview:savedView];
	[savedView animateNotification];
}

- (void)ae_itemSaved:(NSNotification *)notification
{
	self.items = [self.itemManager sortedItems];
	
	[self.tableView reloadData];

	// check if we received a new item, so we can show it to the user. if not, just keep calm and carry on
	AeroCopyItem *item = [[notification userInfo] objectForKey:kAeroCopyUserInfoItemKey];
	if ( ! item)
		return;
	
	NSInteger index = -1;
	for (AeroCopyItem *i in self.items)
	{
		if (i == item)
		{
			index = [self.items indexOfObject:i];
			break;
		}
	}
	
	if (index >= 0)
		[self ae_showSavedNotificationInCellWithIndex:index];
}

- (void)ae_displayTutorialIfNeeded
{
	BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:kAeroCopyTutorialShownKey];
	if ( ! tutorialShown)
	{
		TutorialView *tut = [[TutorialView alloc] initWithFrame:CGRectZero]; // the frame is ignored
		[tut displayTutorialInView:self.detailView.containerView];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAeroCopyTutorialShownKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

#pragma mark - Public

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Items", nil);
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	self.items = [self.itemManager sortedItems];
	self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ae_itemSaved:) name:kAeroCopySavedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ae_itemSaved:) name:kAeroCopyUpdateddNotification object:nil];
	
	UIView *marginView = [[UIView alloc] initWithFrame:AEDCGRectWithSize(CGRectZero, self.tableView.frame.size.width, 5.0)];
	marginView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = marginView;
	self.tableView.tableFooterView = marginView;
	
	self.detailView.frame = AEDCGRectPlaceX(self.detailView.frame, kDetailViewHiddenOrigin);
	self.detailView.dateFormatter = self.dateFormatter;
	[self.detailView configure];

	self.view.frame = AEDCGRectPlaceY(self.view.frame, self.view.frame.size.height);
	[self.view setDefaultRoundedCorners];
	[UIView animateWithDuration:.3 delay:.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.view.frame = AEDCGRectPlaceY(self.view.frame, 0.0);
	} completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	self.tableView = nil;
	self.detailView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger count = [self.items count];
	if (count == 0)
		self.tableView.hidden = YES;
	else
		self.tableView.hidden = NO;
	
	return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"ItemIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	
	AeroCopyItem *item = [self.items objectAtIndexOrNil:indexPath.row];
	
	cell.textLabel.text = item.text;
	cell.textLabel.textColor = MAIN_TEXT_COLOR;
	cell.textLabel.font = [UIFont fontWithName:@"Bariol-Bold" size:18];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:item.date];
	cell.detailTextLabel.textColor = DETAIL_TEXT_COLOR;
	cell.detailTextLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:14];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
	cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
	[cell.selectedBackgroundView setDefaultRoundedCorners];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self.detailView updateViewWithItem:[[self.items objectAtIndexOrNil:indexPath.row] copy]];
	
	if (self.detailView.touchActive)
		return;
	
	[UIView animateWithDuration:0.25 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.detailView.frame = AEDCGRectPlaceX(self.detailView.frame, kDetailViewVisibleOrigin);
	} completion:^(BOOL finished) {
		[self ae_displayTutorialIfNeeded];
	}];
}

@end
