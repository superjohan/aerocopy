//
//  AeroCopyItem.m
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "AeroCopyItem.h"

@implementation AeroCopyItem

@synthesize date = _date;
@synthesize text = _text;

- (id)initWithDate:(NSDate *)date text:(NSString *)text
{
	if ((self = [super init]))
	{
		self.date = date;
		self.text = text;
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	AeroCopyItem *copy = [[[self class] allocWithZone:zone] init];
	copy.date = self.date;
	copy.text = self.text;

	return copy;
}

- (BOOL)isEqual:(id)object
{
	if ( ! [object isKindOfClass:[AeroCopyItem class]])
		return NO;
	
	AeroCopyItem *item = (AeroCopyItem *)object;
	if ([item.text isEqual:self.text]
		&& [item.date isEqualToDate:self.date])
		return YES;
	else
		return NO;
}

@end
