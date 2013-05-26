//
//  AEDNSArrayAdditions.m
//  aerocopy-ios
//
//  Created by Johan Halin on 2/22/12.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AEDNSArrayAdditions.h"

@implementation NSArray (AEDNSArrayAdditions)

- (id)objectAtIndexOrNil:(NSUInteger)index
{
	if (index >= self.count)
		return nil;
	
	return [self objectAtIndex:index];
}

- (id)firstObject
{
	return [self objectAtIndexOrNil:0];
}

@end
