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

    __block Class className;
    __block NSBundle *bundle;
    __block NSObject<GOLDPlugIn> *plugIn;
    __block NSString *bundlePath;

	[builtInplugIns enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        bundlePath = [NSString stringWithFormat:@"%@/%@", builtInplugInsPath, object];
        bundle = [NSBundle bundleWithPath:bundlePath];
        if ([bundle load]) {
            className = [bundle principalClass];
            if ([className conformsToProtocol:NSProtocolFromString(@"GOLDPlugIn")]) {
                plugIn = [[className alloc] initWithPlugInsController:[GOLDPlugInsController sharedPlugInsController]];
                if (![loadedPlugIns objectForKey:[plugIn name]])
                    [plugInsDictionary setObject:plugIn forKey:[plugIn name]];
            } else {
                NSLog(@"%@ -> failed validation", className);
            }
        }
	}];

    if (self.loadedPlugIns) {
        self.loadedPlugIns = nil;
    }

    self.loadedPlugIns = [[NSDictionary alloc] initWithDictionary:plugInsDictionary];
    plugInsDictionary = nil;
}

- (void)drawViews
{
    __weak NSWindow *window = [[GOLDAppDelegate sharedApplication] mainWindow];
    [self.loadedPlugIns enumerateKeysAndObjectsUsingBlock:^(id key, NSObject <GOLDPlugIn> *plugIn, BOOL *stop) {
        if ([plugIn respondsToSelector:@selector(mainView)]) {
        	[[window contentView] addSubview:[plugIn mainView]];
    	}
    }];
}

- (void)executePlugIns
{
    if (self.loadedPlugIns) {
    	[self.loadedPlugIns enumerateKeysAndObjectsUsingBlock:^(NSObject<GOLDPlugIn> *plugInName, id plugIn, BOOL *stop) {
        	[plugIn execute];
    	}];
    }
}

- (NSURL *)applicationDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.zenangst.Keyboard_Cowboy_2"];
}

@end
