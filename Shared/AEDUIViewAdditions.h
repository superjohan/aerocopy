//
//  AEDUIViewAdditions.h
//  aerocopy-ios
//
//  Created by Johan Halin on 18.3.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AEDUIViewAdditions)

- (void)setRoundedCornersWithRadius:(CGFloat)radius;
- (void)setDefaultRoundedCorners; // radius = 10 is usually the Apple default

@end
