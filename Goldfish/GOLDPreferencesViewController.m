//
//  GOLDPreferencesController.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 14/04/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDPreferencesViewController.h"

@interface GOLDPreferencesViewController ()

@end

@implementation GOLDPreferencesViewController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [self setWindowFrameAutosaveName:@"PreferencesWindow"];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}
@end
