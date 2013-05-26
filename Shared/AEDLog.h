//
//  AEDLog.h
//  aerocopy-ios
//
//  Created by Johan Halin on 26.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AEDLOG_LOG(levelName, fmt, ...) NSLog((@"%@ [T:0x%x %@] %s:%d " fmt), levelName, (unsigned int)[NSThread currentThread], ([[NSThread currentThread] isMainThread] ? @"M" : @"S"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define AEDLOG_DEBUG(fmt, ...) AEDLOG_LOG(@"DEBUG", fmt, ##__VA_ARGS__)
#else
#define AEDLOG_DEBUG(...)
#endif

#define AEDLOG_INFO(fmt, ...) AEDLOG_LOG(@"INFO", fmt, ##__VA_ARGS__)
