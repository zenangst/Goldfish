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
#import "GOLDProtocols.h"

static NSString * const kGoldfishPluginProtocol = @"GOLDPlugIn";
static NSString * const kGoldfishFileExtension = @"bundle";

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
    __block NSString *fullBundlePath;

	[builtInplugIns enumerateObjectsUsingBlock:^(NSString *bundlePath, NSUInteger idx, BOOL *stop) {
        fullBundlePath = [NSString stringWithFormat:@"%@/%@", builtInplugInsPath, bundlePath];
        bundle = [NSBundle bundleWithPath:fullBundlePath];

        if ([bundle load]) {
            className = [bundle principalClass];
            if ([className conformsToProtocol:NSProtocolFromString(kGoldfishPluginProtocol)]) {
                plugIn = [self initializePlugin:className withBundleIdentifier:[bundle bundleIdentifier]];
                if (!loadedPlugIns[[plugIn name]]) {
                    plugInsDictionary[[plugIn name]] = plugIn;
                }
                NSLog(@"%@: loaded", [plugIn name]);
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

- (id)initializePlugin:(Class)className withBundleIdentifier:(NSString *)bundleIdentifier
{
	NSObject<GOLDPlugIn> *plugIn = [[className alloc] initWithPlugInsController:[GOLDPlugInsController sharedPlugInsController]];
    plugIn.bundleIdentifier = bundleIdentifier;
	if ([className respondsToSelector:@selector(hasConfiguration)]
	&&  [className hasConfiguration]) {
        [[GOLDPlugInsController sharedPlugInsController] loadConfigurationForPlugIn:plugIn];
    }

    return plugIn;
}

- (NSURL *)applicationDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
}

@end
