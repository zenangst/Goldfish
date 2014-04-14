//
//  GOLDAppDelegate.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Goldfish. All rights reserved.
//

#import "GOLDAppDelegate.h"
#import "GOLDPlugInsLoader.h"
#import "GOLDPreferencesController.h"

@implementation GOLDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect frame = NSMakeRect(0, 0, 320, 240);
    self.preferencesWindow = [[GOLDWindow alloc] initWithContentRect:frame];
    [self.preferencesWindow setTitle:@"Preferences"];

    GOLDPreferencesController *preferencesWindowController = [[GOLDPreferencesController alloc] initWithWindow:self.preferencesWindow];

    self.window = [[GOLDWindow alloc] initWithContentRect:frame];
    [self.window setTitle:@"Goldfish"];

    NSWindowController *windowController = [[NSWindowController alloc] initWithWindow:self.window];
    [windowController loadWindow];
    [windowController setWindowFrameAutosaveName:@"MainWindow"];
    [self.window setWindowController:windowController];

    [NSApp activateIgnoringOtherApps:YES];
    [[self.window windowController] showWindow:self];

    [[GOLDPlugInsLoader sharedLoader] loadPlugIns];
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
    [[GOLDPlugInsLoader sharedLoader] drawViews];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [NSApp activateIgnoringOtherApps:YES];
    [[self.window windowController] showWindow:self];
    return YES;
}

- (NSWindowController *)windowController
{
    NSWindowController *windowController = [self.window windowController];
    return windowController;
}

@end
