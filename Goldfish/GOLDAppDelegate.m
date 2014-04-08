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
}

@end
