//
//  AeroCopyDetailView.h
//  aerocopy-ios
//
//  Created by Johan Halin on 3.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AeroCopyItem;

static const CGFloat kDetailViewHiddenOrigin = 330.0;
static const CGFloat kDetailViewVisibleOrigin = -10.0;

@interface AeroCopyDetailView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign, readonly) BOOL touchActive;

- (void)configure;
- (void)updateViewWithItem:(AeroCopyItem *)item;

@end
