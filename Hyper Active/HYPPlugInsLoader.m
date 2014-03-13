//
//  HYPPlugInsLoader.m
//  Hyper Active
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "HYPAppDelegate.h"
#import "HYPPlugInsLoader.h"
#import "HYPPlugInsController.h"
#import "HYPPlugIn.h"

static NSString * const kHyperFileExtension = @"bundle";

@implementation HYPPlugInsLoader

@synthesize loadedPlugIns;

- (void)loadPlugIns
{
    NSString *builtInplugInsPath = [[NSBundle mainBundle] builtInPlugInsPath];
    NSMutableDictionary *plugInsDictionary = [[NSMutableDictionary alloc] init];
    NSArray *builtInplugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtInplugInsPath error:nil];
    NSBundle *bundle;
    Class plugInClassName;
    NSObject <HYPPlugIn> *plugIn;
    NSString *bundlePath;

    for (NSString *filename in builtInplugIns) {
        bundlePath = [NSString stringWithFormat:@"%@/%@", builtInplugInsPath, filename];
        bundle = [NSBundle bundleWithPath:bundlePath];
        if ([bundle load]) {
            plugInClassName = [bundle principalClass];
            plugIn = [[plugInClassName alloc] initWithPlugInsController:[HYPPlugInsController sharedPlugInsController]];
            if (![loadedPlugIns objectForKey:[plugIn name]])
            [plugInsDictionary setObject:plugIn forKey:[plugIn name]];
        }
    }

    if (self.loadedPlugIns) {
        self.loadedPlugIns = nil;
    }
    self.loadedPlugIns = [[NSDictionary alloc] initWithDictionary:plugInsDictionary];
    plugInsDictionary = nil;
}

- (void)drawViews
{
    HYPAppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    for (NSObject <HYPPlugIn> *plugIn in self.loadedPlugIns) {
    	if ([plugIn respondsToSelector:@selector(mainView)]) {
        	[[appDelegate.window contentView] addSubview:[plugIn mainView]];
    	}
    }
}

- (void)executePlugIns
{
    if (self.loadedPlugIns) {
    	for (NSString *plugInName in self.loadedPlugIns) {
    		[self executePlugInWithName:plugInName];
    	}
    }
}

- (void)executePlugInWithName:(NSString *)plugInName
{
    NSObject <HYPPlugIn> *plugIn;
    plugIn = [loadedPlugIns objectForKey:plugInName];
	if (plugIn) {
        if ([plugIn respondsToSelector:@selector(execute)]) {
      		[plugIn execute];
        }
	}
}

- (NSURL *)applicationDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.zenangst.Keyboard_Cowboy_2"];
}

@end
