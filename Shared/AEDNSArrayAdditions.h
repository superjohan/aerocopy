//
//  AEDNSArrayAdditions.h
//  aerocopy-ios
//
//  Created by Johan Halin on 2/22/12.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AEDNSArrayAdditions)

- (id)objectAtIndexOrNil:(NSUInteger)index;
- (id)firstObject;

@end
