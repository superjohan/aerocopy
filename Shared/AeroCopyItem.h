//
//  AeroCopyItem.h
//  aerocopy-ios
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AeroCopyItem : NSObject <NSCopying>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *text;

- (id)initWithDate:(NSDate *)date text:(NSString *)text;

@end
