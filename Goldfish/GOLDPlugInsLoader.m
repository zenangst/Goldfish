//
//  GOLDPlugInsLoader.m
//  Goldfish
//
//  Created by Christoffer Winterkvist on 2/21/14.
//  Copyright (c) 2014 Christoffer Winterkvist. All rights reserved.
//

#import "GOLDAppDelegate.h"
#import "GOLDPlugInsLoader.h"
#import "GOLDPlugInsController.h"
#import "GOLDPlugIn.h"

static NSString * const kHyperFileExtension = @"bundle";

@implementation GOLDPlugInsLoader

@synthesize loadedPlugIns;

+ (instancetype)sharedLoader
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (void)loadPlugIns
{
    NSString *builtInplugInsPath = [[NSBundle mainBundle] builtInPlugInsPath];
    NSMutableDictionary *plugInsDictionary = [[NSMutableDictionary alloc] init];
    NSArray *builtInplugIns = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:builtInplugInsPath error:nil];
    NSBundle *bundle;
    Class plugInClassName;
    NSObject <GOLDPlugIn> *plugIn;
    NSString *bundlePath;

    for (NSString *filename in builtInplugIns) {
        bundlePath = [NSString stringWithFormat:@"%@/%@", builtInplugInsPath, filename];
        bundle = [NSBundle bundleWithPath:bundlePath];
        if ([bundle load]) {
            plugInClassName = [bundle principalClass];
            plugIn = [[plugInClassName alloc] initWithPlugInsController:[GOLDPlugInsController sharedPlugInsController]];
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
    __weak NSWindow *window = [[GOLDAppDelegate sharedApplication] mainWindow];
    NSObject <GOLDPlugIn> *plugIn;

    for (NSString *plugInName in self.loadedPlugIns) {
        plugIn = [self.loadedPlugIns objectForKey:plugInName];
    	if ([plugIn respondsToSelector:@selector(mainView)]) {
        	[[window contentView] addSubview:[plugIn mainView]];
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
    NSObject <GOLDPlugIn> *plugIn;
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