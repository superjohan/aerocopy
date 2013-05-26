//
//  AeroCopyMainViewController.h
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

@class AeroCopyItemManager;
@class AeroCopyDetailView;

@interface AeroCopyMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet AeroCopyDetailView *detailView;
@property (nonatomic, strong) AeroCopyItemManager *itemManager;

@end
