//
//  GOLDWindow.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 14/04/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDWindow.h"

@implementation GOLDWindow

static float const kTitleBarHeight = 40.0f;

- (instancetype)initWithContentRect:(NSRect)rect
{
    self = [super initWithContentRect:rect styleMask:NSTitledWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask|NSClosableWindowMask
                                             backing:NSBackingStoreBuffered
                                               defer:NO];
    if (self) {
        self.titleBarHeight = kTitleBarHeight;
        [[self contentView] setAutoresizesSubviews:YES];
    }
    return self;
}

@end
