//
//  GOLDAppDelegate.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "GOLDAppDelegate.h"
#import "GOLDPlugInsLoader.h"

@implementation GOLDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect frame = NSMakeRect(0, 0, 320, 240);
    self.window = [[NSWindow alloc] initWithContentRect:frame styleMask:NSTitledWindowMask|NSResizableWindowMask|NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
    [self.window setHasShadow:YES];
    [self.window setTitle:@"Goldfish"];
    [[self.window contentView] setAutoresizesSubviews:YES];

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
