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
    GOLDPlugInsLoader *plugInsLoader = [[GOLDPlugInsLoader alloc] init];
    [plugInsLoader loadPlugIns];
    [plugInsLoader drawViews];
    [plugInsLoader executePlugInWithName:@"Git"];

    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 320, 240) styleMask:NSTitledWindowMask|NSResizableWindowMask|NSClosableWindowMask backing:NSBackingStoreBuffered defer:NO];
    [window setHasShadow:YES];

    self.windowController = [[NSWindowController alloc] initWithWindow:window];
    [self.windowController loadWindow];
    [self.windowController showWindow:self];
    [self.windowController setWindowFrameAutosaveName:@"MainWindow"];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.windowController showWindow:self];
    return YES;
}

@end
