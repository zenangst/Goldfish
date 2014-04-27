//
//  GOLDAppDelegate.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDAppDelegate.h"
#import "GOLDPlugInsLoader.h"
#import "GOLDPreferencesViewController.h"

@implementation GOLDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect frame = NSMakeRect(0, 0, 320, 240);
    self.preferencesWindow = [[GOLDWindow alloc] initWithContentRect:frame];
    [self.preferencesWindow setTitle:@"Preferences"];

    GOLDPreferencesViewController *preferencesWindowController = [[GOLDPreferencesViewController alloc] initWithWindow:self.preferencesWindow];
    [preferencesWindowController loadWindow];

    self.mainViewController = [[GOLDMainViewController alloc] init];
    [self.mainViewController showWindow];
    [[GOLDPlugInsLoader sharedLoader] loadPlugIns];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.mainViewController showWindow];
    return YES;
}

@end
