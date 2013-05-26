//
//  SavedNotificationView.m
//  aerocopy-ios
//
//  Created by Johan Halin on 17.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "SavedNotificationView.h"
#import "AeroCopyConstants.h"
#import "AEDCGHelpers.h"

const NSInteger kArrowTag = 1;

@implementation SavedNotificationView

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = MAIN_TEXT_COLOR;
		
		UIImageView *cloudImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cloud"]];
		cloudImage.frame = AECGRectWithSize(cloudImage.frame, cloudImage.image.size.width, cloudImage.image.size.height);
		[self addSubview:cloudImage];
		
		UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
		arrowImage.frame = AECGRectWithSize(arrowImage.frame, arrowImage.image.size.width, arrowImage.image.size.height);
		arrowImage.tag = kArrowTag;
		[self addSubview:arrowImage];
		
		UILabel *savedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		savedLabel.text = NSLocalizedString(@"Saved.", nil);
		savedLabel.font = [UIFont fontWithName:@"Bariol-Bold" size:21];
		savedLabel.textColor = [UIColor whiteColor];
		savedLabel.backgroundColor = [UIColor clearColor];
		[savedLabel sizeToFit];
		[self addSubview:savedLabel];
		
		savedLabel.frame = AECGRectPlace(savedLabel.frame, floor(CGRectGetMidX(self.frame) - (savedLabel.frame.size.width / 2.0) - (cloudImage.frame.size.width / 2.0) - 5.0), floor(CGRectGetMidY(self.frame) - (savedLabel.frame.size.height / 2.0)));
		cloudImage.frame = AECGRectPlace(cloudImage.frame, savedLabel.frame.origin.x + savedLabel.frame.size.width + 10.0, floor(CGRectGetMidY(self.frame) - (cloudImage.frame.size.height / 2.0)));
		arrowImage.frame = AECGRectPlace(arrowImage.frame, cloudImage.frame.origin.x + 9.0, cloudImage.frame.origin.y + cloudImage.frame.size.height);
	}

	return self;
}

- (void)animateNotification
{
	__block UIImageView *arrow = (UIImageView *)[self viewWithTag:kArrowTag];

	[UIView animateWithDuration:.7 delay:.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
		arrow.frame = AECGRectPlaceY(arrow.frame, arrow.frame.origin.y - arrow.frame.size.height);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:.5 delay:1.5 options:0 animations:^{
			self.alpha = 0;
		} completion:^(BOOL finished) {
			[self removeFromSuperview];
		}];
	}];
}

@end
