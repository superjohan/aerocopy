//
//  AEDUIViewAdditions.m
//  aerocopy-ios
//
//  Created by Johan Halin on 18.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AEDUIViewAdditions.h"

@implementation UIView (AEDUIViewAdditions)

- (void)setRoundedCornersWithRadius:(CGFloat)radius
{
	self.layer.cornerRadius = radius;
	self.layer.masksToBounds = YES;
}

- (void)setDefaultRoundedCorners
{
	[self setRoundedCornersWithRadius:10.0];
}

@end
