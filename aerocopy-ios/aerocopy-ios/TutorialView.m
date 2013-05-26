//
//  TutorialView.m
//  aerocopy-ios
//
//  Created by Johan Halin on 10.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "TutorialView.h"
#import "AEDCGHelpers.h"
#import "AeroCopyConstants.h"
#import "AEDUIViewAdditions.h"

@interface TutorialView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *fingerView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, strong) UIButton *dismissButton;
@end

@implementation TutorialView

@synthesize containerView = _containerView;
@synthesize fingerView = _fingerView;
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize dismissButton = _dismissButton;

#pragma mark - Private

- (void)ae_dismissView:(id)sender
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
		self.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

- (void)ae_performFingerAnimation
{
	__block TutorialView *bself = self;
	
	[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
		bself.fingerView.alpha = 1.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			bself.fingerView.frame = AECGRectPlaceX(bself.fingerView.frame, bself.endPoint.x);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
				bself.fingerView.alpha = 0.0;
			} completion:^(BOOL finished) {
				bself.fingerView.frame = AECGRectPlaceX(bself.fingerView.frame, bself.startPoint.x);
				[bself performSelector:@selector(ae_performFingerAnimation) withObject:nil afterDelay:0.5];
			}];
		}];
	}];
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = INFO_MASK_COLOR;
		
		self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250.0, 250.0)];
		self.containerView.backgroundColor = INFO_BACKGROUND_COLOR;
		self.containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[self.containerView setDefaultRoundedCorners];
		
		UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		infoLabel.font = [UIFont fontWithName:@"Bariol-Regular" size:32];
		infoLabel.text = NSLocalizedString(@"Swipe to close.", nil);
		[infoLabel sizeToFit];
		infoLabel.frame = AECGRectPlace(infoLabel.frame, floor((self.containerView.frame.size.width / 2.0) - (infoLabel.frame.size.width / 2.0)), 20.0);
		infoLabel.textColor = MAIN_TEXT_COLOR;
		infoLabel.shadowColor = INFO_TEXT_SHADOW_COLOR;
		infoLabel.shadowOffset = CGSizeMake(0, 1.0);
		infoLabel.backgroundColor = [UIColor clearColor];
		[self.containerView addSubview:infoLabel];
		
		self.fingerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finger"]];
		self.fingerView.frame = AECGRectWithSize(self.fingerView.frame, self.fingerView.image.size.width, self.fingerView.image.size.height);
		self.fingerView.frame = AECGRectPlace(self.fingerView.frame, 20.0, floor(self.containerView.frame.size.height / 2.0) - 40.0);
		[self.containerView addSubview:self.fingerView];
		
		self.startPoint = self.fingerView.frame.origin;
		self.endPoint = CGPointMake(self.containerView.frame.size.width - self.fingerView.frame.size.width - self.startPoint.x, self.startPoint.y);
		
		self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.dismissButton.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
		[self.dismissButton addTarget:self action:@selector(ae_dismissView:) forControlEvents:UIControlEventTouchUpInside];
		[self.containerView addSubview:self.dismissButton];
		
		[self addSubview:self.containerView];
	}

	return self;
}

- (void)displayTutorialInView:(UIView *)view
{
	self.frame = view.bounds;
	self.alpha = 0.0;
	self.fingerView.alpha = 0.0;
	[view addSubview:self];
	
	[UIView animateWithDuration:0.3 delay:0.5 options:0 animations:^{
		self.alpha = 1.0;
	} completion:^(BOOL finished) {
		[self ae_performFingerAnimation];
	}];
	
	[self performSelector:@selector(ae_dismissView:) withObject:nil afterDelay:10.0];
}

@end
