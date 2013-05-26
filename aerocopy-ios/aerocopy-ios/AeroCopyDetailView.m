//
//  AeroCopyDetailView.m
//  aerocopy-ios
//
//  Created by Johan Halin on 3.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyDetailView.h"
#import "AeroCopyItem.h"
#import "AEDCGHelpers.h"
#import "AEDUIViewAdditions.h"

@interface AeroCopyDetailView ()
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign, readwrite) BOOL touchActive;
@end

@implementation AeroCopyDetailView

@synthesize containerView = _containerView;
@synthesize webView = _webView;
@synthesize dateFormatter = _dateFormatter;
@synthesize panRecognizer = _panRecognizer;
@synthesize touchActive = _touchActive;

#pragma mark - Private

- (void)ae_handlePanGesture:(UIPanGestureRecognizer *)panRecognizer
{
	CGFloat x = floor([self.panRecognizer translationInView:self].x);
	if (x > kDetailViewVisibleOrigin)
		self.frame = AECGRectPlaceX(self.frame, x);
	else
		self.frame = AECGRectPlaceX(self.frame, kDetailViewVisibleOrigin);

	if (self.panRecognizer.state == UIGestureRecognizerStateEnded)
	{
		self.touchActive = NO;
		
		CGFloat x = kDetailViewVisibleOrigin;
		if (self.frame.origin.x > 50 || [self.panRecognizer velocityInView:self].x > 100)
			x = kDetailViewHiddenOrigin;
		
		[UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.frame = AECGRectPlaceX(self.frame, x);
		} completion:nil];
	}
	else
		self.touchActive = YES;
}

#pragma mark - Public

- (void)configure
{
	[self.containerView setDefaultRoundedCorners];
	
	self.webView.scrollView.scrollEnabled = NO;
	
	self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ae_handlePanGesture:)];
	self.panRecognizer.delegate = self; 
	[self addGestureRecognizer:self.panRecognizer];
}

- (void)updateViewWithItem:(AeroCopyItem *)item
{
	NSString *htmlString = [NSString stringWithFormat:@"<html><style type=\"text/css\"> #text { color: black; font-size: 21px; } #date { #222: black; font-size: 14px; } body { font-family: Bariol-Regular; } a { color: #ff4509; text-decoration: none; } #container { height: 480px; display: table; width: 280px; margin: 0 auto; } #content { display: table-cell; vertical-align: middle; padding-bottom: 20px; }</style><body><div id=\"container\"><div id=\"content\"><p id=\"text\">%@</p><p id=\"date\">saved %@</p></div></div></body></html>", item.text, [self.dateFormatter stringFromDate:item.date]];
	
	[self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ([request.URL.scheme isEqualToString:@"about"])
		return YES;
	else
	{
		[[UIApplication sharedApplication] openURL:request.URL];
		
		return NO;
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	if (gestureRecognizer == self.panRecognizer)
		return YES;
	else
		return NO;
}

@end
