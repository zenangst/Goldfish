//
//  HYPAppDelegate.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPAppDelegate.h"
#import "HYPPlugInsLoader.h"

@implementation HYPAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  HYPPlugInsLoader *pluginLoader = [[HYPPlugInsLoader alloc] init];
}

@end
