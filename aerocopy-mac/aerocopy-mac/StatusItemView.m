//
//  StatusItemView.m
//  aerocopy-mac
//
//  Created by Johan Halin on 12.2.2012.
//  Copyright (c) 2012 Aero Deko. All rights reserved.
//

#import "StatusItemView.h"
#import "AeroCopyAppDelegate.h"

@implementation StatusItemView

@synthesize owner = _owner;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	if ([self.owner respondsToSelector:@selector(itemClicked:)])
		[self.owner itemClicked:self];
}

@end
